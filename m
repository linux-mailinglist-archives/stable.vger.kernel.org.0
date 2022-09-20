Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839775BEB05
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 18:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiITQVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 12:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiITQUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 12:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45475F22
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 09:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D58F861FAC
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 16:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF246C433D6;
        Tue, 20 Sep 2022 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663690769;
        bh=Yh6trLmyLOdzsXAhMOagSo5m95jpAwFBPB91QQgrzAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Umi4O5/CHNQpwz4P2ihzS+rW2pup+5mGXWfvwWHl9rI4lKj497XBrHvkOYCwHV2hp
         oykNMo2fKKv0imuodPj8HHzkOAAsCRm+4jmWSWnAkoItFocVX3tkw3l5Uhn6DmPLce
         QSP78vUlBB1kVSKKtrPkhuhW5QXOBAfOYkJSCFl8=
Date:   Tue, 20 Sep 2022 18:19:26 +0200
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
Message-ID: <YynoDtKjvDx0vlOR@kroah.com>
References: <20220909185557.21255-1-risbhat@amazon.com>
 <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 03:34:04PM +0000, Bhatnagar, Rishabh wrote:
> Gentle reminder to review this patch series.

Gentle reminder to never top-post :)

Also, it's up to the KVM maintainers if they wish to review this or not.
I can't make them care about old and obsolete kernels like 5.10.y.  Why
not just use 5.15.y or newer?

thanks,

greg k-h
