Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C3321B7A3
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGJOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgGJOCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:51 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A5392084D;
        Fri, 10 Jul 2020 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389770;
        bh=/Rq0rVarHY5HDapJHmnVvuczxFcJQeLnfaGxc2WQKks=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=leHk41W5N/sFkIxrqEyQNeReOnO6Pp/T6HXDKBBkohMxsiONNQ7y2kDgQUGyYfvrj
         BnNl8XY9ZQ/fFqCexbNNv/Qjg0QLSaR+zDsWyFqRwZbwH/u/RCFf+3RKbX/6GuNkH/
         RWeY0HLx703N3k5W/li75ngOv4vRyhNNnoUy2Wy4=
Date:   Fri, 10 Jul 2020 14:02:49 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sivaprakash Murugesan <sivaprak@codeaurora.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org, bhelgaas@google.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5/9] phy: qcom-qmp: use correct values for ipq8074 gen2 pcie phy init
In-Reply-To: <1593940680-2363-6-git-send-email-sivaprak@codeaurora.org>
References: <1593940680-2363-6-git-send-email-sivaprak@codeaurora.org>
Message-Id: <20200710140250.9A5392084D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: eef243d04b2b ("phy: qcom-qmp: Add support for IPQ8074").

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187.

v5.7.7: Build OK!
v5.4.50: Build OK!
v4.19.131: Build OK!
v4.14.187: Failed to apply! Possible dependencies:
    e2248617ec157 ("phy: qcom-qmp: Move register offsets to header file")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
