Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E2523794
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiEKPnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 11:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiEKPnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 11:43:03 -0400
X-Greylist: delayed 747 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 May 2022 08:43:00 PDT
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E56980A1
        for <stable@vger.kernel.org>; Wed, 11 May 2022 08:42:59 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 24BFUCjv341625
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 16:30:13 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9d:7e02:9be5:c549:1a72:4709])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 24BFU6xk1786704
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 17:30:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1652283006; bh=6HAmgC7gvqAC1QW7WFidRJCmZN+wg27UcaabMFiwfzs=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=RyH4MxmBpGQ6UoIz1uON6b6oL/PUpV+j74K4um6hRPS/DlPF0u95dDXcvtrXgA4Q1
         kApV0e/+sWyA6E4T6pI5rZYPbloLn95odU+92t7gL96LqY4Y8SyRFgF2at3hCpRWIh
         6iiBOvhOhmfrtpSd/zdWzOkSLyoGcLf98DXh+dQk=
Received: (nullmailer pid 346479 invoked by uid 1000);
        Wed, 11 May 2022 15:30:06 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     stable@vger.kernel.org
Cc:     Greg KH <greg@kroah.com>, bugzilla-daemon@kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [Bug 215967] New: Kernel build fails if CONFIG_REGULATOR is unset
Organization: m
References: <bug-215967-208809@https.bugzilla.kernel.org/>
        <YnuqQAb2CIRyfZPX@kroah.com>
Date:   Wed, 11 May 2022 17:30:06 +0200
In-Reply-To: <YnuqQAb2CIRyfZPX@kroah.com> (Greg KH's message of "Wed, 11 May
        2022 14:21:20 +0200")
Message-ID: <87wnesccjl.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <greg@kroah.com> writes:
> On Wed, May 11, 2022 at 07:44:39AM +0000, bugzilla-daemon@kernel.org wrot=
e:
>
>> Compilation of "drivers/usb/phy/phy-generic.c" fails reproducible if
>> CONFIG_REGULATOR is unset, because function "devm_regulator_get_exclusiv=
e" is
>> undeclared but nevertheless used.
>> The offending patch propably is commit 03e607cbb2931374db1825f371e9c7f28=
526d3f4
>> upstream
>
> Can you please send this information to the stable@vger.kernel.org
> mailing list and we will work on it there?

Please backport commit 51dfb6ca3728 ("regulator: consumer: Add missing
stubs to regulator/consumer.h") to v5.10 stable and older stable
releases where 03e607cbb2931374db1825f371e9c7f28526d3f4 is backported



Bj=C3=B8rn
