Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4CA174073
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 20:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgB1Toy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 14:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB1Tox (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 14:44:53 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 365E324695;
        Fri, 28 Feb 2020 19:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582919093;
        bh=p4fdOqo7B8V7wAdUQcuT6Jl1h7U7qEqYTM40pz7DsFg=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=vgotfkcMbhIg08/qQzilwRU/EJe/BQ/ck/fI2Tmiv7iEWPrjs6grsJunKgC9HbSOQ
         /kCnnrgqiDqyR5lw/DjYn4+W6fW+U5JxEslnd4hmMeMN1i0FiWGJgqdbNBd/iMGrIb
         yNUtx8ZX1NvHrdJ+jvkYC70fMqJUvkk1kBZ1WQrw=
Date:   Fri, 28 Feb 2020 19:44:52 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     linuxtv-commits@linuxtv.org
Cc:     Johan Hovold <johan@kernel.org>, Lubomir Rintel <lkundrak@v3.sk>
Cc:     stable@vger.kernel.org
Subject: Re: [git:media_tree/master] media: usbtv: fix control-message timeouts
In-Reply-To: <E1j6FUn-008x6M-Hs@www.linuxtv.org>
References: <E1j6FUn-008x6M-Hs@www.linuxtv.org>
Message-Id: <20200228194453.365E324695@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: f3d27f34fdd7 ("[media] usbtv: Add driver for Fushicai USBTV007 video frame grabber").

The bot has tested the following trees: v5.5.6, v5.4.22, v4.19.106, v4.14.171, v4.9.214, v4.4.214.

v5.5.6: Build OK!
v5.4.22: Build OK!
v4.19.106: Build OK!
v4.14.171: Build OK!
v4.9.214: Failed to apply! Possible dependencies:
    62de7d99dcfe ("[media] usbtv: don't do DMA on stack")
    b3168c87c049 ("media: usbtv: fix brightness and contrast controls")
    c53a846c48f2 ("[media] usbtv: add video controls")

v4.4.214: Failed to apply! Possible dependencies:
    62de7d99dcfe ("[media] usbtv: don't do DMA on stack")
    b3168c87c049 ("media: usbtv: fix brightness and contrast controls")
    c53a846c48f2 ("[media] usbtv: add video controls")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
