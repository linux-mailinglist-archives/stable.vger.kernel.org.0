Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94E517D094
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCGXUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgCGXUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:33 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E390207FD;
        Sat,  7 Mar 2020 23:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623232;
        bh=htgCQAkgNYZAuywRNyGvUv8lYSBVI2oe1k0h0pz24ss=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=x91JjQPAAOcX0HpbS4xInwUaxYNpCPK7FFsax6IcSlXELUR87AWxD016BJ2+6qtrg
         Z+juBBfPVmJFBDIrWeSrD0JfQU0zEuTaq2aVawghg6rnlHF6QjIQIU3bYEM/qEsnNk
         ESWZ0ekUme7TgC4VZc2jZCz5VRZx9p+DYDHhgKkQ=
Date:   Sat, 07 Mar 2020 23:20:31 +0000
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
Message-Id: <20200307232032.9E390207FD@mail.kernel.org>
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
