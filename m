Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F03233358
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 15:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgG3NsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 09:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgG3NsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 09:48:12 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22ACD208A9;
        Thu, 30 Jul 2020 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596116892;
        bh=+WJWYk54OL/1vPSWOJ6HwuSe00Yy5dS+KFGS9cE09YQ=;
        h=Date:From:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:From;
        b=veNCmgAMxCzUAd2I5Zen1ZceMd+cGbrC4NfeK24OqEnryhbkAycSWw0ozNjAM5Mxo
         XgfNvt+VECz0QTvt99a7d7pJDUDylMA1PgYzYI4uuKTfGAb0YRXtQVFRyaTjZTVx3c
         8zVL23rmesBVKkWJJ3gQAc22JHmtV5hdx9J3PZQA=
Date:   Thu, 30 Jul 2020 13:48:11 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
To:     Jonathan Cameron <jic23@kernel.org>
CC:     Christian Eggers <ceggers@arri.de>, <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: trigger: hrtimer: Disable irqs before calling iio_trigger_poll()
In-Reply-To: <20200727145900.4563-1-ceggers@arri.de>
References: <20200727145900.4563-1-ceggers@arri.de>
Message-Id: <20200730134812.22ACD208A9@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.

v5.7.11: Build OK!
v5.4.54: Build OK!
v4.19.135: Build OK!
v4.14.190: Build OK!
v4.9.231: Build OK!
v4.4.231: Failed to apply! Possible dependencies:
    ac5006a2a558 ("iio: trigger: Introduce IIO hrtimer based trigger")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
