Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297AA8C55F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 03:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfHNBBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 21:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbfHNBBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 21:01:44 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA50206C2;
        Wed, 14 Aug 2019 01:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565744503;
        bh=ZJLTxC9eodCsLg0f0IZXO3MX4Vygc+cNKAlpPCDsh/E=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=E3Y8un+yDUhSa+DlXJKMMNZxzIXeEmpjRCKWtA9Eal1KThYQ7JpjdZFM365I1U6Gn
         wKpA2fpxi3DauEqX+4nkliRf5p6yQBOgj8z/hvbSBvwbCz+4VTKQYEkpJnRNUOFAJh
         T3Qzlor5DY4BViv8xYwWhD1kZFI/Bch+/9+vNREE=
Date:   Wed, 14 Aug 2019 01:01:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] media: tm6000: double free if usb disconnect while streaming
In-Reply-To: <20190813201439.22480-1-sean@mess.org>
References: <20190813201439.22480-1-sean@mess.org>
Message-Id: <20190814010143.1BA50206C2@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189, v4.4.189.

v5.2.8: Build OK!
v4.19.66: Build OK!
v4.14.138: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.189: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.189: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
