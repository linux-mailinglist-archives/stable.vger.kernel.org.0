Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D42E6C9D
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 07:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfJ1G7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 02:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbfJ1G7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 02:59:20 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8C3208C0;
        Mon, 28 Oct 2019 06:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572245959;
        bh=X+DGLPW1NH1GddDto9slEA+llFD+SZqQ4t5yZRwcxgA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=A6Bb1sPIgUOAd7tjkshfGanusI8+dFjMRia9h9+NKna1DFWFB+1/U9rE0XTvb7Guw
         Kv4CLQFpxvNVLvCN/pxOt8P/JYlBm2GhlqWKEK0dS7v9HE0gP/9QAIUBZ/KpThwmPN
         y6jFdnAUEovOmk+wq3jz1lkgZixH35pdoXYZ3+H0=
Date:   Mon, 28 Oct 2019 06:59:18 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Cc:     stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active
In-Reply-To: <20191027152323.24326-1-pbonzini@redhat.com>
References: <20191027152323.24326-1-pbonzini@redhat.com>
Message-Id: <20191028065919.AB8C3208C0@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.3.7, v4.19.80, v4.14.150, v4.9.197, v4.4.197.

v5.3.7: Build OK!
v4.19.80: Failed to apply! Possible dependencies:
    Unable to calculate

v4.14.150: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.197: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.197: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
