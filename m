Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFC75BF9ED
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 10:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiIUI60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 04:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiIUI6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 04:58:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC747C1C4
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 01:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 274DBB82EC1
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4786CC433C1;
        Wed, 21 Sep 2022 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663750701;
        bh=CXfVbMZPYk/sF4QuEfeSbdzl/yh1BxVb+ld3g9DZpx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RTRaM3SWoj3I5RNX6mIjCT+h3mD40ndQIvuGcifJWSYNe6kUmkzuCaANW6ceRDgMs
         tW8lh3W/3Jz4IrhH95TRMCEFluwDlv13EgvcjxwYehl8+1sJDIosXdyjOCAQRIehHx
         9mT7ogUr+Zz4QRtyva6wmIcu0g3f/D/73wqxH7fs=
Date:   Wed, 21 Sep 2022 10:58:18 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Bhatnagar, Rishabh" <risbhat@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jitindar Singh, Suraj" <surajjs@amazon.com>,
        "Bacco, Mike" <mbacco@amazon.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH 0/9] KVM backports to 5.10
Message-ID: <YyrSKtN2VqnAuevk@kroah.com>
References: <20220909185557.21255-1-risbhat@amazon.com>
 <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
 <YynoDtKjvDx0vlOR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YynoDtKjvDx0vlOR@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 06:19:26PM +0200, gregkh@linuxfoundation.org wrote:
> On Tue, Sep 20, 2022 at 03:34:04PM +0000, Bhatnagar, Rishabh wrote:
> > Gentle reminder to review this patch series.
> 
> Gentle reminder to never top-post :)
> 
> Also, it's up to the KVM maintainers if they wish to review this or not.
> I can't make them care about old and obsolete kernels like 5.10.y.  Why
> not just use 5.15.y or newer?

Given the lack of responses here from the KVM developers, I'll drop this
from my mbox and wait for them to be properly reviewed and resend before
considering them for a stable release.

thanks,

greg k-h
