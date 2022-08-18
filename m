Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2FD597D7A
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 06:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242800AbiHREav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 00:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238358AbiHREau (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 00:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE6B9C8ED
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660797049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cc+fqw+2caKrO2A9j2XsAEZrkexp4FaWlrCWO+71c/4=;
        b=RtCDef0904GBZnrJCPD/i/B+sSU+P2BjDR0z/W9IfDhWkxaUVaw6lrrVkGl7PHNZlo/y+c
        RLulqTqFcIirl9pTl/zW5H4IofGiyEGExp0iTH9OJ9zJk1GVdqdArSg/YUpzdOQNCfDn6f
        pr4v7Fq0BfoNWszBOjZGrAGjmY2Bbbc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-28-Z6uN3HUTN7q8eFhjlhfAcQ-1; Thu, 18 Aug 2022 00:30:47 -0400
X-MC-Unique: Z6uN3HUTN7q8eFhjlhfAcQ-1
Received: by mail-pf1-f197.google.com with SMTP id 18-20020a621712000000b0053264bf07caso314650pfx.23
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=cc+fqw+2caKrO2A9j2XsAEZrkexp4FaWlrCWO+71c/4=;
        b=O3fsHr4Y3Dw55pqYABiSPtgUecpU7pAZ1YW3toC0lYrsSieuxYHe0pMaiNTwOTdrxR
         eK9+THRX6kwyHQowtm3vslWatUg70LjIWSlyuaaJlH1rRbL9NO8eurk/DGYdbZAgkI1d
         kD4YexiZ0Pti17tDRWRY8ZEAm+7wBKd18CezbmemdlBqEf6Ey3CNm2ktvCeqJ9lq4U3j
         8/voejGa+LCrRVdNtJ9gD027C3N68eR8ng8w8Q3LEn+P2Bm7zKPSFT2IVeOr0Dcl/18G
         b/8lytnjYCTNv+GLoEjXbm3f6T1mYw+4SRwNi+ek+xAMLw0Iq1q6N0RX19b6ByPX8Byd
         UxKA==
X-Gm-Message-State: ACgBeo1E+EmsvqoY/ifcVY+jTas1e6PX1BHMyAgbWTclqIgImT7hG4V3
        PKTLF5TyLYNQSzhSC3krrCaQEviiEoG/irJZArQoBhlwm4n0PuedBHTPuMhihdrK9u2324WD+Uu
        WwPDiablEUhZqFw/x
X-Received: by 2002:aa7:9f1d:0:b0:52e:2401:e630 with SMTP id g29-20020aa79f1d000000b0052e2401e630mr1296257pfr.18.1660797046637;
        Wed, 17 Aug 2022 21:30:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6W8WM1xuHZK9uqgbHqqTqDjDQD3LUCSSEfMtbxqd/so2IJ34v32co6XFDyBhGTbYfd3Ny9jg==
X-Received: by 2002:aa7:9f1d:0:b0:52e:2401:e630 with SMTP id g29-20020aa79f1d000000b0052e2401e630mr1296241pfr.18.1660797046390;
        Wed, 17 Aug 2022 21:30:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e126-20020a621e84000000b00535d094d6ecsm235434pfe.108.2022.08.17.21.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 21:30:45 -0700 (PDT)
Date:   Thu, 18 Aug 2022 12:25:47 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
        bhe@redhat.com, ebiederm@xmission.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kexec: clean up
 arch_kexec_kernel_verify_sig" failed to apply to 5.15-stable tree
Message-ID: <20220818042547.herg4vamrj6quixe@Rk>
References: <1660564084173149@kroah.com>
 <20220815124125.GD17705@kitsune.suse.cz>
 <YvpEPMGebrrhp8Yf@kroah.com>
 <4b217b8801fe66a0fd71dad62571059d67f784bc.camel@linux.ibm.com>
 <YvzZz865jqWBEC7G@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YvzZz865jqWBEC7G@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 02:06:39PM +0200, Greg KH wrote:
>On Mon, Aug 15, 2022 at 09:22:39AM -0400, Mimi Zohar wrote:
>> On Mon, 2022-08-15 at 15:03 +0200, Greg KH wrote:
>> > On Mon, Aug 15, 2022 at 02:41:25PM +0200, Michal Suchánek wrote:
>> > > Hello,
>> > >
>> > > it applies on top of 105e10e2cf1c
>> >
>> > I see no such commit id in Linus's tree, what am I missing here?
>> >
>> > confused,
>>
>> 0738eceb6201 kexec: drop weak attribute from functions

The above one is actually not needed.

>> 65d9a9a60fd7 kexec_file: drop weak attribute from functions
>
>That is 2 commit ids, not just one as Michal said, why?
>
>I am totally confused here, sorry.  Can I have a list of the git ids
>that need to be applied here, including the original git id of the patch
>that started this whole thread off, so I know _EXACTLY_ what I need to
>apply to the tree (and to what trees?)

This patch i.e. "[PATCH] kexec: clean up arch_kexec_kernel_verify_sig"
is a prerequisite for "[PATCH Patch] arm64: kexec_file: use more system
keyrings to verify kernel image signature". I just replied to 'FAILED:
patch "[PATCH] arm64: kexec_file: use more system keyrings to verify
kernel" failed to apply to 5.15-stable tree' with a full list of the git
ids.

>
>thanks,
>
>greg k-h
>

-- 
Best regards,
Coiby

