Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6712218DF
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgGPA1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgGPA1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:43 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A3620775;
        Thu, 16 Jul 2020 00:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859262;
        bh=sNm9Iy30rCtguvdFMxey5mZXpgi3WYp8Xaa9yn8XI68=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=zWU9VnXAqU8SclJgHX0SABnUc20nqFHiAAiW9jWSvOteZeyA4zH2m/p9ArwNg4lkE
         3Rgmm2PXjLXMZBBq8DSfD5JcKF/BAQzeL9tNDjayaV/mstkCHahJW2InisAaMivOK0
         qR1MbEYZyKifiNdosGIRhbqOcNIP/Xwv/g15oVuk=
Date:   Thu, 16 Jul 2020 00:27:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] vhost/scsi: fix up req type endian-ness
In-Reply-To: <20200710104849.406023-1-mst@redhat.com>
References: <20200710104849.406023-1-mst@redhat.com>
Message-Id: <20200716002742.97A3620775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Build OK!
v4.19.132: Failed to apply! Possible dependencies:
    0d02dbd68c47b ("vhost/scsi: Respond to control queue operations")

v4.14.188: Failed to apply! Possible dependencies:
    0d02dbd68c47b ("vhost/scsi: Respond to control queue operations")

v4.9.230: Failed to apply! Possible dependencies:
    0d02dbd68c47b ("vhost/scsi: Respond to control queue operations")

v4.4.230: Failed to apply! Possible dependencies:
    0d02dbd68c47b ("vhost/scsi: Respond to control queue operations")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
