Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2984017D09A
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgCGXUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgCGXUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:41 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6826A2075E;
        Sat,  7 Mar 2020 23:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623240;
        bh=NJ2J6G2KLoUghazQv6pzRoMOjD48/PyB87BX6fUfYQk=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=0eFH7poqVAlUQhadFYTvLMZPySw7w0KYkioyJtWxhx0ak9y+o9A3avxANsMKtoTV1
         GqDCTeKz12NZn1wO8C5WB0HztO9WUgM5BU3QQV738iSUlHkldhNnTjGSP/pZp28Asp
         NYEDL5NiAERL3Mr80kkbJut7Ix/qtHY3EaS7lmjM=
Date:   Sat, 07 Mar 2020 23:20:39 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sibi Sankar <sibis@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
To:     bjorn.andersson@linaro.org, mathieu.poirier@linaro.org
Cc:     agross@kernel.org, ohad@wizery.com, linux-arm-msm@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] remoteproc: qcom_q6v5_mss: Don't reassign mpss region on shutdown
In-Reply-To: <20200304194729.27979-2-sibis@codeaurora.org>
References: <20200304194729.27979-2-sibis@codeaurora.org>
Message-Id: <20200307232040.6826A2075E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch").

The bot has tested the following trees: v5.5.7, v5.4.23, v4.19.107.

v5.5.7: Build OK!
v5.4.23: Build OK!
v4.19.107: Failed to apply! Possible dependencies:
    0304530ddd29 ("remoteproc: qcom: q6v5-mss: Refactor mba load/unload sequence")
    7dd8ade24dc2 ("remoteproc: qcom: q6v5-mss: Add custom dump function for modem")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
