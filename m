Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC9D1B30C0
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDUT4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgDUT4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:09 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB7EA2074B;
        Tue, 21 Apr 2020 19:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498969;
        bh=LmjYNr0RAZiIpUq7RwRNtQ5TnnB8gzOt2xMEWc8ozqI=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=E0VZzxyJB2b7cLkYjeE8n/nlh0TsYOu57xgGuLvU+n2QOShC5AkqbCft3W0jlLD8N
         813HgwqsJdxXsCy+jJqrYTuD5y/DzcpW84QgRPlL9kSc+reJJONZ3cRZH/f5XXabLq
         Vc1WO66TGOs2cbmwKRRDpq13dLCbGq2tl5+vwOQk=
Date:   Tue, 21 Apr 2020 19:56:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
To:     Ilan Peer <ilan.peer@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 v5.7 5/6] iwlwifi: mvm: Do not declare support for ACK Enabled Aggregation
In-Reply-To: <iwlwifi.20200417100405.53dbc3c6c36b.Idfe118546b92cc31548b2211472a5303c7de5909@changeid>
References: <iwlwifi.20200417100405.53dbc3c6c36b.Idfe118546b92cc31548b2211472a5303c7de5909@changeid>
Message-Id: <20200421195608.CB7EA2074B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.19+

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Build OK!
v4.19.116: Failed to apply! Possible dependencies:
    57a3a454f303 ("iwlwifi: split HE capabilities between AP and STA")
    80aaa9c16415 ("mac80211: Add he_capa debugfs entry")
    add7453ad62f ("wireless: align to draft 11ax D3.0")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
