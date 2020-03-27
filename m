Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983BD195986
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 16:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgC0PDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 11:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbgC0PDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 11:03:45 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C641208E4;
        Fri, 27 Mar 2020 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585321424;
        bh=NNW0pm+Pz9Hcd3OqFqsC4fX1aTMsUjDD/OKXZhdtBUc=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=GC5qqBlz/Cwe+pgwtezltUzvPbNroyq+NLjgtBHlxaczYID9L8+zSbaCCLfvVRXG/
         vwVfRN7hdYbm7Smx0jDlnFFRCaBUME9upj7y5bqmbjDzcAwbktRU8PUi7aZNS/EkrJ
         xFtFRGcN2MKgtetbJfWo6pQ3AaRzpD7Hxc2pXswQ=
Date:   Fri, 27 Mar 2020 15:03:43 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
To:     bsingharora@gmail.com, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] kernel/taskstats: fix wrong nla type for {cgroup,task}stats policy
In-Reply-To: <1585191042-9935-1-git-send-email-laoar.shao@gmail.com>
References: <1585191042-9935-1-git-send-email-laoar.shao@gmail.com>
Message-Id: <20200327150344.5C641208E4@mail.kernel.org>
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
v4.14.174: Build OK!
v4.9.217: Build OK!
v4.4.217: Failed to apply! Possible dependencies:
    243d52126184 ("taskstats: fix the length of cgroupstats_cmd_get_policy")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
