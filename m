Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E5D189178
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 23:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgCQWa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 18:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgCQWa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 18:30:26 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8E020752;
        Tue, 17 Mar 2020 22:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584484226;
        bh=v3clwKm3O3VBWbUOhsbM62uTF0zT3G4gwRpIStA0fe8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Fu3WG6V4uty5sT8dg+usP8yEqpBitBPrqERa6RyqQn+YuCGgDX4ywwk+vPS5FepeF
         /kO0Ae/M2rUPfHqV7M5kBZucM78HyshjHYYwp4FhksNQUBWhgjoRAHHZnUj4eh4JAH
         iP6etVVJDdrh6ysy9+YgOGpOnfGXar095TYpQpMQ=
Date:   Tue, 17 Mar 2020 22:30:25 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v1] mpt3sas: Fix kernel panic observed on soft HBA unplug
In-Reply-To: <1584001735-22719-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1584001735-22719-1-git-send-email-sreekanth.reddy@broadcom.com>
Message-Id: <20200317223026.0B8E020752@mail.kernel.org>
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
    c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")

v4.4.216: Failed to apply! Possible dependencies:
    96902835e7e2 ("mpt3sas: Eliminate conditional locking in mpt3sas_scsih_issue_tm()")
    98c56ad32c33 ("mpt3sas: Eliminate dead sleep_flag code")
    c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
