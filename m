Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A50549E5F9
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiA0PZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:25:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42826 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiA0PZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:25:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 212776154D
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5F3C340E4;
        Thu, 27 Jan 2022 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643297080;
        bh=f8YHuYmCtQzrMVjTZADYtk/hQLux2eBy7FAuzJybjAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kOao3KJJlmvRJ2sXwmPrcK7jjgjj9ixcuzwpX2KKbH6hrdScRd7f59fXqqVOLaz9c
         0dfvaQVF12paNjwGLA140QP6seuOWJoO3sqLtxMcuoCgbgVB1GJB/NouNSFK2gGYLR
         ZeUHmh9R3HfU2frPCiLVqR+/NNnsZd9ydhsWmzAc=
Date:   Thu, 27 Jan 2022 16:24:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Bhutani, Amit" <Amit.Bhutani@amd.com>,
        "Tsao, Anson" <anson.tsao@amd.com>
Subject: Re: suspend to idle fixes for SATA for 5.15.y
Message-ID: <YfK5NdC7eaUQb45M@kroah.com>
References: <BL1PR12MB51579C4626B8B584F5C50F44E25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51579C4626B8B584F5C50F44E25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 02:22:14PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Can you please bring 
> commit 7c5f641a5914ce0303b06bcfcd7674ee64aeebe9 ("ata: libahci: Adjust behavior when StorageD3Enable _DSD is set")

Already in 5.15.7

> and
> commit 1527f69204fe35f341cb599f1cb01bd02daf4374 ("ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile")

Also in 5.15.7

> 
> to 5.15.y?  These help suspend to idle failures with supported SATA disks and should make sense for LTS Kernel.

Are you sure you are testing the right branch?

thanks,

greg k-h
