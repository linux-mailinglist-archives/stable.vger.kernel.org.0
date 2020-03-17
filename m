Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D56018916E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 23:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgCQWaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 18:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgCQWaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 18:30:22 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7720620409;
        Tue, 17 Mar 2020 22:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584484221;
        bh=T6IgJfak24WeMQqJA8JyeD/uhgR6SJO+VwL4E9jC7nE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=DWm9iKKyiFoMsb+ZnmHNn32Y4uhJ7VUVRV/LsT+/tpcelbhhKU+cfdcHRoDf8MFLw
         dnsNeuNApOZghEofs4Adsq4GkMa1rpCLKcFtgvhLIftxXSqwGdpFjEit7SAl33px3g
         Gk1wFUNFjVZa9DDG/NHOltAIqFOx9k/gXVS/5RNk=
Date:   Tue, 17 Mar 2020 22:30:20 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [GIT PULL 6/6] intel_th: pci: Add Elkhart Lake CPU support
In-Reply-To: <20200317062215.15598-7-alexander.shishkin@linux.intel.com>
References: <20200317062215.15598-7-alexander.shishkin@linux.intel.com>
Message-Id: <20200317223021.7720620409@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.

v5.5.9: Build OK!
v5.4.25: Build OK!
v4.19.109: Build OK!
v4.14.173: Build OK!
v4.9.216: Failed to apply! Possible dependencies:
    4aa5aed2b6f2 ("intel_th: pci: Add Ice Lake NNPI support")
    59d08d00d43c ("intel_th: pci: Add Ice Lake PCH support")
    88385866bab8 ("intel_th: pci: Add Elkhart Lake SOC support")
    920ce7c33db2 ("intel_th: pci: Add Cedar Fork PCH support")
    9c78255fdde4 ("intel_th: pci: Add Tiger Lake support")
    9d55499d8da4 ("intel_th: pci: Add Jasper Lake PCH support")
    e60e9a4b231a ("intel_th: pci: Add Comet Lake support")

v4.4.216: Failed to apply! Possible dependencies:
    4aa5aed2b6f2 ("intel_th: pci: Add Ice Lake NNPI support")
    59d08d00d43c ("intel_th: pci: Add Ice Lake PCH support")
    88385866bab8 ("intel_th: pci: Add Elkhart Lake SOC support")
    920ce7c33db2 ("intel_th: pci: Add Cedar Fork PCH support")
    9c78255fdde4 ("intel_th: pci: Add Tiger Lake support")
    9d55499d8da4 ("intel_th: pci: Add Jasper Lake PCH support")
    e60e9a4b231a ("intel_th: pci: Add Comet Lake support")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
