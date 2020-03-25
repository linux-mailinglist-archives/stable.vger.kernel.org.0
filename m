Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22536191E57
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 02:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgCYBCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 21:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCYBCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 21:02:00 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A25632076A;
        Wed, 25 Mar 2020 01:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585098119;
        bh=THm7hnZmohNLxGwf0nad1iO7T9b9hejDN5HpxC6xU74=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=S6YigvvI3kSoDyHQ49XpmluaBE1KPAhhr2/Cy2aWFvJO2e2Smy7M7MRtZbD15fIU3
         pEq97gIBaf9lJK88tvz1jp2lSqzzuU9Np/sfgdO6nByVyPNWrmdEJrf2uea4f2S5oV
         ukQG7wuMTe+TZJpS98GyW/x6IOC637N4KNi4kCN4=
Date:   Wed, 25 Mar 2020 01:01:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH resend] extcon: axp288: Add wakeup support
In-Reply-To: <20200323215939.79008-1-hdegoede@redhat.com>
References: <20200323215939.79008-1-hdegoede@redhat.com>
Message-Id: <20200325010159.A25632076A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.

v5.5.11: Build OK!
v5.4.27: Build OK!
v4.19.112: Build OK!
v4.14.174: Build failed! Errors:
    drivers/extcon/extcon-axp288.c:326:21: error: ‘dev’ undeclared (first use in this function); did you mean ‘pdev’?

v4.9.217: Failed to apply! Possible dependencies:
    dd3a55fc688b ("extcon: axp288: Fix the module not auto-loading")

v4.4.217: Failed to apply! Possible dependencies:
    dd3a55fc688b ("extcon: axp288: Fix the module not auto-loading")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
