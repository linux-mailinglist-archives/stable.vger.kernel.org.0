Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63E326E02F
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgIQQCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 12:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbgIQQBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:01:48 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7968020708;
        Thu, 17 Sep 2020 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600358008;
        bh=M2gFxqmtjjAWg/oGRYKTsRTZLNarF0mdV6aFeWm3RZ0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=TEY4P/Z3V+4nyTHT7QFM+b9jJ808FfgkCUxfwlUjqmEkEUhNGePV4gKg62ZHv3pxI
         ZKZebu2xtPd0qiW/5vzX39rvcBt9Uk4rv0A80HTwJ18DdzthDRzD6lWD7IHXI9l7vd
         fn6nCdxi5LxPQ0prWjyyln4mK0fcMX3OyrNZ1Ndw=
Date:   Thu, 17 Sep 2020 15:53:27 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Alex Hung <alex.hung@canonical.com>
To:     rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH][V2] ACPI: video: use ACPI backlight for HP 635 Notebook
In-Reply-To: <20200913223403.59175-1-alex.hung@canonical.com>
References: <20200913223403.59175-1-alex.hung@canonical.com>
Message-Id: <20200917155328.7968020708@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.9, v5.4.65, v4.19.145, v4.14.198, v4.9.236, v4.4.236.

v5.8.9: Build OK!
v5.4.65: Build OK!
v4.19.145: Build OK!
v4.14.198: Build OK!
v4.9.236: Build OK!
v4.4.236: Failed to apply! Possible dependencies:
    49eb5208220a ("ACPI / video: Add a quirk to force acpi-video backlight on SAMSUNG 530U4E/540U4E")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
