Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F53F4A4033
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358230AbiAaKac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358192AbiAaK3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:29:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD109C061756
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 02:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D35F9CE10F4
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 10:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9025FC340E8;
        Mon, 31 Jan 2022 10:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643624962;
        bh=1zsl6JsdA+Ur9on5j77PTd7/yf8S4W5s3NNkz0+WUQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1kf5HJAOjQ/rpy8QABOCJrlXzsvg5R2Ngu/YbcY6p1ZyqMri8zH7aMgPPSYDtvQt
         qKXA8cfW8pre/3pLl5IrpW7DmyzJH0VnRf1KhZmKqtFJC/Iux0pXeWbqZ/qnSScVdx
         WIRgqjA+ttwjii8L9XBzo0kugQfee+KHjRahQcC8=
Date:   Mon, 31 Jan 2022 11:29:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH stable 5.16 v1 0/3] KVM: nVMX: Fix Windows 11 + WSL2 +
 Enlightened VMCS
Message-ID: <Yfe5/wGy9JT8lIjg@kroah.com>
References: <20220129152947.3136637-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220129152947.3136637-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 04:29:44PM +0100, Vitaly Kuznetsov wrote:
> This series is the essential subset of "[PATCH v3 0/5] KVM: nVMX: Fix
> Windows 11 + WSL2 + Enlightened VMCS" which got merged upstream recently.
> It fixes Windows 11 guests with enabled Hyper-V role on KVM when eVMCS is
> in use.

All now queued up, thanks.

greg k-h
