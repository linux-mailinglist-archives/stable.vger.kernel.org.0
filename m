Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740323624BC
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 17:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbhDPP5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 11:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235897AbhDPP5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 11:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08876610CE;
        Fri, 16 Apr 2021 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618588619;
        bh=O00x3WoqG//kJyJftw2hAUxtBiQzR9vHjG/0/3YXKms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rHLk2Akxo47x+91d0TfZb0S1U/YqkzBuF73V2AwBIjNZHypJdB9AxKNAapAWaN32Y
         Q2Avy28W2Hb0W4fITujfO6nshCdrn05cBOxHdvbhHDvrPmoq7l4RooAnXjLxLbFMc3
         UXuS2TYzWUa3vHCSnlw234UVFsjOkyCvpuTZ/6wYRmAgdSy3iS1O2rUAdrxydZsyg1
         mPL51E1M7zjBRhevWKevMhPZdjLmpohmzO+dRRXNJ7eqn3frHRi1AkdIBEgKSxBeor
         1KOtqGigdIyCuVEwaDQX14fnIVQyEG6f3RtLhd1nVGl06SqocmQhzpKQDQCLn6X0KC
         7q9YYG5pJpVCQ==
Date:   Sat, 17 Apr 2021 00:56:53 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, hch@infradead.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Shyam-sundar.S-k@amd.com
Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210416155653.GA31818@redsun51.ssa.fujisawa.hgst.com>
References: <1618556075-24589-1-git-send-email-Prike.Liang@amd.com>
 <1618556075-24589-2-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618556075-24589-2-git-send-email-Prike.Liang@amd.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 02:54:34PM +0800, Prike Liang wrote:
> In the NVMe controller default suspend-resume seems only save/restore the
> NVMe link state by APST opt and the NVMe remains in D0 during this time.
> Then the NVMe device will be shutdown by SMU firmware in the s2idle entry
> and then will lost the NVMe power context during s2idle resume.Finally,
> the NVMe command queue request will be processed abnormally and result
> in access timeout.This issue can be settled by using PCIe power set with
> simple suspend-resume process path instead of APST get/set opt.
> 
> In this patch prepare a PCIe RC bus flag to identify the platform whether
> need the quirk.
> 
> Cc: <stable@vger.kernel.org> # 5.11+
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> [ck: split patches for nvme and pcie]
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Just a "Suggested-by:" from me is fine. I'm glad you were able to
confirm this is successful, so I can add my Ack as well

Acked-by: Keith Busch <kbusch@kernel.org>
