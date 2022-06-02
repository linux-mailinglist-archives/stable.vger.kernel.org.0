Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BA453C155
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 01:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbiFBX33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 19:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiFBX33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 19:29:29 -0400
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de [141.2.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36C731DE8
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 16:29:27 -0700 (PDT)
Received: from smtpauth2.cluster.uni-frankfurt.de ([10.1.1.238])
        by mailout.rz.uni-frankfurt.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwuFq-00028d-IN; Fri, 03 Jun 2022 01:29:26 +0200
Received: from p57bcf53e.dip0.t-ipconnect.de ([87.188.245.62] helo=[192.168.2.17])
        by smtpauth2.cluster.uni-frankfurt.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwuFq-0006G5-Gp; Fri, 03 Jun 2022 01:29:26 +0200
Message-ID: <88b0eb42-41eb-af0e-285c-05f86a5c5fea@med.uni-frankfurt.de>
Date:   Fri, 3 Jun 2022 01:29:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: boot loop since 5.17.6
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <YpkY0RLWki4PJ49y@kroah.com>
From:   Thomas Sattler <sattler@med.uni-frankfurt.de>
In-Reply-To: <YpkY0RLWki4PJ49y@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 02.06.22 um 22:08 schrieb Greg KH:
> On Thu, Jun 02, 2022 at 06:14:43PM +0200, Thomas Sattler wrote:
>> After applying "patch-5.17.5-6.part198.patch" compilation is
>> broken. Still after applying "patch-5.17.5-6.part199.patch".
>> After applying "patch-5.17.5-6.part200.patch", compilation
>> works again but the resulting kernel now fails to boot.
> 
> I have no idea what those random patches are, please can you say what
> the upstream commit is?

I took what I reverted from patch-5.17.5-6.xz. In your tree it
matches what Nathan mentioned (60d2b0b1018a) plus d17f64c29512.

Now, knowing that they were two patchsets, I compiled 5.17.12
twice, once without 60d2b0b1018a and once without d17f64c29512.

And it turns out it is 60d2b0b1018a which breaks my system.

Thomas
