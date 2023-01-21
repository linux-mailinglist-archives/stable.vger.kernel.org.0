Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7B26764EF
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 08:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjAUH2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 02:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjAUH2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 02:28:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549277028D;
        Fri, 20 Jan 2023 23:28:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36D77CE1D4D;
        Sat, 21 Jan 2023 07:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF3BC433D2;
        Sat, 21 Jan 2023 07:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674286083;
        bh=o/NnGHbW3/LKlx06TTfc39eoc7OZYE08m75gGJnvJ2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XzHqMaRnB3nDhyixTBYjav7evFKYot0WVYwXfegsKtxSdmb8halMMu/rmIqCuWGir
         imDiQ1DMdLcx+/3gIq87i+sgu0JVevccOTAkTGozAMEo3l3oBRyZuk34QmOLxJuRkw
         zX+hMux9LwcwLWLhfHJhWM4m8rwQUrgmwFsnaV0g=
Date:   Sat, 21 Jan 2023 08:28:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        zhi.wang.linux@gmail.com, chao.gao@intel.com,
        shaoqin.huang@intel.com, vkuznets@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH v6 1/6] KVM: x86: only allow exits disable before
 vCPUs created
Message-ID: <Y8uUAFv9Qz7GvSei@kroah.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-2-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121020738.2973-2-kechenl@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 02:07:33AM +0000, Kechen Lu wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Since VMX and SVM both would never update the control bits if exits
> are disable after vCPUs are created, only allow setting exits
> disable flag before vCPU creation.
> 
> Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Nit, no blank line between fixes and signed-off-by please.

And an RFC on v6?  An RFC usually means "I don't think this is correct
so do not take it".  How can you do that for 6 versions?  And know that
no one will take an RFC series for that reason (or at least I will
not...)

thanks,

greg k-h
