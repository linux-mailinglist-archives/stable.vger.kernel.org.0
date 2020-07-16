Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9922218E3
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGPA1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgGPA1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:38 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EEA920791;
        Thu, 16 Jul 2020 00:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859257;
        bh=m1MRnKS+pnNH1neNLPymbpiqbcyxoP5hSCyJ3ceWZ0s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=x+2e+imgA1de7Uc2gXxvOvz0BJr5w8rloWg2eWnKMbKdzGvs9QFMqy2eDbkomLERD
         Ypt0J78qjK069QMek7cvtPTKKZsBACCdAAfuZN8hc8in2K7ntD5t7+tPdVvMajR8P5
         KnSodGc0KEv5HmUfav18Vi0H2DlMyE5JscAa4pCM=
Date:   Thu, 16 Jul 2020 00:27:36 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Grant Likely <grant.likely@secretlab.ca>
To:     unlisted-recipients:; (no To-header on input)
Cc:     linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc:     Darren Hart <darren@dvhart.com>
Cc:     Jiri Kosina <jikos@kernel.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] hid-input: Fix devices that return multiple bytes in battery report
In-Reply-To: <20200710151939.4894-1-grant.likely@arm.com>
References: <20200710151939.4894-1-grant.likely@arm.com>
Message-Id: <20200716002737.5EEA920791@mail.kernel.org>
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
v4.19.132: Build OK!
v4.14.188: Build OK!
v4.9.230: Failed to apply! Possible dependencies:
    581c4484769e6 ("HID: input: map digitizer battery usage")

v4.4.230: Failed to apply! Possible dependencies:
    581c4484769e6 ("HID: input: map digitizer battery usage")
    5d9374cf5f66e ("HID: input: ignore the battery in OKLICK Laser BTmouse")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
