Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD917B0F5
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCEVxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgCEVxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 16:53:42 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12C420848;
        Thu,  5 Mar 2020 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583445222;
        bh=htgCQAkgNYZAuywRNyGvUv8lYSBVI2oe1k0h0pz24ss=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=k05+/EGqTX5MqYcMISgDhGousthI3On+d9bvOYkmpF9+9mbUvp5kvOTfxzlJCMVDP
         /Yb6vLUhrFF82ZPkFGhdJ5zhc6AY7xFqqIr8Mu9cYrrN1M5IcQvXUx6eFQamKEmn94
         IOSwMPmuE25hRnXzDJrHHekSO/x7RwyCdnht8gR4=
Date:   Thu, 05 Mar 2020 21:53:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org, mathieu.poirier@linaro.org
Cc:     agross@kernel.org, ohad@wizery.com, linux-arm-msm@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4 3/3] remoteproc: qcom_q6v5_mss: Reload the mba region on coredump
In-Reply-To: <20200304194729.27979-4-sibis@codeaurora.org>
References: <20200304194729.27979-4-sibis@codeaurora.org>
Message-Id: <20200305215341.E12C420848@mail.kernel.org>
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
    e9ad659019a6 ("remoteproc: qcom_q6v5_mss: Don't reassign mpss region on shutdown")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
