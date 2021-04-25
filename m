Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1DE36A7F8
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 17:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhDYPaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 11:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhDYPaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Apr 2021 11:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B88261288;
        Sun, 25 Apr 2021 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619364565;
        bh=XUF0f4QvX/WN3mBMvuv0XL0kkMoCnBcfY3IPb7Lb6bA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LpDp0LKYQRoO4DGXhSzuGVT7BUfIX3/N0KlAribDO5cqtENhU5AI1cXP4bGdvZrSn
         D9PbAKFrKeF3mf5PLWlUnskiHqMMW1jvsqFIdM3vGBudxsvjvDrsB0VAS1K4xz8CWK
         ExDVQoxN9I/CoC3gmodTtpWipzSLVbmhW5j0yA2+rHKs3DeuQQ7IHoDgM4n0vtmF0z
         kPQkvRNA+7Y/ySbX2vjynPkkWX0Dk7qcTa2XnzJh/yQogeHraKSvDsHByn2frtjhrP
         oHyXbWIDbBMwfastQzZ69Vf8dxxahTUYl4z/bnm9bJq1VT47uYbLcDlojGK9NgGXLo
         9Z9DQ+xN821+g==
Received: by pali.im (Postfix)
        id 7F63A89A; Sun, 25 Apr 2021 17:29:22 +0200 (CEST)
Date:   Sun, 25 Apr 2021 17:29:22 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        linux-pci@vger.kernel.org,
        =?utf-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        stable@vger.kernel.org, Zachary Zhang <zhangzg@marvell.com>
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062 SATA
 controller
Message-ID: <20210425152922.b4iwrq3h7uoh5j5z@pali>
References: <20210317115924.31885-1-kabel@kernel.org>
 <20210317224549.GA93134@bjorn-Precision-5520>
 <20210416155400.695f7629@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210416155400.695f7629@dellmb>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday 16 April 2021 15:54:00 Marek Behún wrote:
> On Wed, 17 Mar 2021 17:45:49 -0500
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
> > Can you please open a report at bugzilla.kernel.org and attach the
> > complete "sudo lspci -vv" output for both systems?  I think it's OK to
> > collect these with the patch applied; we should still be able to see
> > the information we use to compute the MPS values.  But please include
> > the CONFIG_PCIE_BUS_* settings and any "pcie_bus_*" kernel command
> > line arguments.
> 
> Bjorn, I have submitted a report on bugzilla 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=212695
> 
> is this enough?
> 
> Marek

Bjorn, it is enough? Or is something else required to include this patch?
