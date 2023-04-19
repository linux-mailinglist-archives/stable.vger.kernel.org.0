Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50A56E73C8
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjDSHRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDSHRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:17:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0096B46B1;
        Wed, 19 Apr 2023 00:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B99F61F4D;
        Wed, 19 Apr 2023 07:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE072C433D2;
        Wed, 19 Apr 2023 07:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681888638;
        bh=WfsfEA+C45EUPKy/+wp1HfM/3wu+373l0SAHQL/9jGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I+aqmSpXVTqfTyLnNLfbmugTVG3uBnD9QK/0C/KdhJ/ofvNZFnUImiDIns8Hy651R
         jybhmGswZCJoQSFUxYcUyujaFKO4MQcke028UsShvgCTNQqqJ9eLGodlVHYoY8bi/d
         XAOs6ylBKtymt3IdqHjGhB2PSnqStPbmkBKKG88VCBOdLUBlJ33TEl9GyzrBQiAHkQ
         zAwKbS4HrSOF2qDHT8HKPJWzL6dIrKyKN5Ka5p5iQNNUZZ8ktjpi4IVuYxFilJKTcL
         K1eql1Ic7f//cfeNfCTzWeR0srDUpiDJ1CdB/SfMwFc5l63fq+3k23XbCsRNW/11LP
         /dNp+cObCpOSQ==
Date:   Wed, 19 Apr 2023 08:17:11 +0100
From:   Lee Jones <lee@kernel.org>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Bhatnagar, Rishabh" <risbhat@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jitindar Singh, Suraj" <surajjs@amazon.com>,
        "Bacco, Mike" <mbacco@amazon.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/9] KVM backports to 5.10
Message-ID: <20230419071711.GA493399@google.com>
References: <20220909185557.21255-1-risbhat@amazon.com>
 <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
 <YynoDtKjvDx0vlOR@kroah.com>
 <YyrSKtN2VqnAuevk@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyrSKtN2VqnAuevk@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Sep 2022, gregkh@linuxfoundation.org wrote:

> On Tue, Sep 20, 2022 at 06:19:26PM +0200, gregkh@linuxfoundation.org wrote:
> > On Tue, Sep 20, 2022 at 03:34:04PM +0000, Bhatnagar, Rishabh wrote:
> > > Gentle reminder to review this patch series.
> > 
> > Gentle reminder to never top-post :)
> > 
> > Also, it's up to the KVM maintainers if they wish to review this or not.
> > I can't make them care about old and obsolete kernels like 5.10.y.  Why
> > not just use 5.15.y or newer?
> 
> Given the lack of responses here from the KVM developers, I'll drop this
> from my mbox and wait for them to be properly reviewed and resend before
> considering them for a stable release.

KVM maintainers,

Would someone be kind enough to take a look at this for Greg please?

Note that at least one of the patches in this set has been identified as
a fix for a serious security issue regarding the compromise of guest
kernels due to the mishandling of flush operations.

Please could someone confirm or otherwise that this is relevant for
v5.10.y and older?

Thank you.

-- 
Lee Jones [李琼斯]
