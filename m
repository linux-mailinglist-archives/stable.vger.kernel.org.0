Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC75596CC8
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 12:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbiHQKZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 06:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239088AbiHQKZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 06:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE3F5A3E9
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 03:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660731941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qMDzcOfwqLuolGFfSupjsfhRs5BkxlK3rWVZXMJ9FdU=;
        b=XguJmezYu+o/GsVFyctfQWnzCqk1WA+59HJ73w2dj3e013OlIrDA0UVqVYEdi61TcbJvCh
        zZqvC1sZr6fIY4GHmGiBEfOdBOGS0KGljd/G548bQRA95A+nuH2tSDiB7sZMb4ZrStDPMv
        OR3XomGJBHawSvdNoIkhihQEjpALrOU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-83-onnS4XENP6K_QcbMMnaGgw-1; Wed, 17 Aug 2022 06:25:40 -0400
X-MC-Unique: onnS4XENP6K_QcbMMnaGgw-1
Received: by mail-pj1-f70.google.com with SMTP id s4-20020a17090a760400b001f3120342daso5288694pjk.4
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 03:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qMDzcOfwqLuolGFfSupjsfhRs5BkxlK3rWVZXMJ9FdU=;
        b=CvQwqgD7qu90dzdeVMCYWI/yiV8WyjR8ZUAd8S3ntH8jbn9npLLSnr3zf9KAk6klk6
         KDsLEclgO5A2p2OAszVEP0NjTKJZoCxRSiYCylTonMvPnFXmBH28m0f+tSZxiEsCZtso
         bxL43Dsm1m7Umd8Lo94Eg9CdrSCEdj2tSF0LSqrXtARTEFPwbRRM2DbOKezQrs3+NqfG
         LHMf1PNxxwlj7+0OLRMCJ9HKMXSdCLNqH+bAzBk/BTwvvM3P6gLVeHQFEIb556TvNltQ
         6OfxnrRWXUyGhL6+hql1I5gsziZqyQAfpFUMwJBZPf4LHImyHRMfr/xXml1wh+NZZoCI
         AU6w==
X-Gm-Message-State: ACgBeo1ehxaWO3+WfN7DdrAxQ88rzjfuByg+yYN8MlGEfJODSjMwSCJR
        fIC5yast1b2XEf0tAMUia4QHJs5VZgNywDO2bMqw99KedV00kJ+vItSE7mxevEADAWQqnc0Q2gh
        qCKzpM/keWnl0DFce
X-Received: by 2002:a63:1202:0:b0:427:7f15:4711 with SMTP id h2-20020a631202000000b004277f154711mr15034383pgl.550.1660731939148;
        Wed, 17 Aug 2022 03:25:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5r/2cmBVhJR0+Bmr+tIAB1tgrB+UsjKE2/eOycqHJXCVmbw5YdccCEwPnYxLybEtF8kUwdFA==
X-Received: by 2002:a63:1202:0:b0:427:7f15:4711 with SMTP id h2-20020a631202000000b004277f154711mr15034369pgl.550.1660731938863;
        Wed, 17 Aug 2022 03:25:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jn15-20020a170903050f00b0016e808dbe55sm1089347plb.96.2022.08.17.03.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 03:25:38 -0700 (PDT)
Date:   Wed, 17 Aug 2022 18:22:30 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, bhe@redhat.com,
        msuchanek@suse.de, will@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <20220817102230.3x343jotxz7ckxcy@Rk>
References: <166057758347124@kroah.com>
 <20220816063256.qzc6jh744i2zc6ou@Rk>
 <YvtOfWDg2SXdcqgL@kroah.com>
 <20220816104559.xwovh5y4bcx6n37a@Rk>
 <f8266ed176b5eac096344c739ea86d756e6394c3.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f8266ed176b5eac096344c739ea86d756e6394c3.camel@linux.ibm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 09:14:32AM -0400, Mimi Zohar wrote:
>On Tue, 2022-08-16 at 18:45 +0800, Coiby Xu wrote:
>> On Tue, Aug 16, 2022 at 09:59:57AM +0200, Greg KH wrote:
>>
>> >Hopefully the git ids can be stable when they are merged to a
>> >maintainer's tree.
>
>A missing Ack was added to one of the commits resulting in a forced
>rebase.
>
>>
>> I notice the commit ids of these patches in current next-integrity tree
>> are still different from Linus's tree. It seems there is no way to avoid
>> manually backporting a patch for similar cases unless the commit ids are
>> automatically fixed when Linus merges the patch or we could match a
>> commit by its subject.
>
>After "fixing" the topic branch merge message, I forgot to push it out
>to the next-integrity branch. (Will be fixed shortly.)  Other than the
>merge message commit itself, the commits in Linus' tree and the next-
>integrity branch are the same.  The pull request was based on the
>integrity-6.20 tag.
>
>Tip of linux-integrity/next-integrity:
>$ git log 1d212f9037b0 | head -2
>commit 1d212f9037b035e638d53834bfe8d3094ca1d04c
>Merge: c808a6ec7166 0828c4a39be5
>
>Tip of the my local branch and what's in Linus' branch:
>$ git log 88b61b130334 | head -2
>commit 88b61b130334212f8f05175e291c04adeb2bf30b
>Merge: c808a6ec7166 0828c4a39be5
>
>The pull request tag:
>$ git log integrity-6.20 | head -2
>commit 88b61b130334212f8f05175e291c04adeb2bf30b
>Merge: c808a6ec7166 0828c4a39be5

Thanks for the explanation! Previously I thought the commit ids are
different because Linus may have picked up the patches from the next
tree and the git ids can only be determined in the last moment. But
according to [2][3], Linus always merges a signed tag from a subsystem
maintainer and unlike cherry-pick-up a merge could preserves the commit
ids so a subsystem maintainer could know stable commit ids.

[2] https://www.spinics.net/lists/newbies/msg63520.html
[3] https://docs.kernel.org/maintainer/pull-requests.html

>
>Mimi
>

-- 
Best regards,
Coiby

