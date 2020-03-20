Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9F018D666
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 18:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCTR7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 13:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbgCTR7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 13:59:48 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1B920777;
        Fri, 20 Mar 2020 17:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584727187;
        bh=JGduhAWLYv+CF15IVMpmt5trFOPY/6Hqc84oxY0N8Yo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=hm189xk3FbFkgWk3xqykVZiEXPdouV4LjVZh2BAtGov9oO+587oVbLsk5OWEyBtPV
         v76fT3AClXMNfNEl6Bzir7rEYS7gJsZGwXAW997LthkVPk1h1ieldn5fmSMkNmgEP1
         7E9TC9WzkXFsEstcufePxJlgyUDWB3hQ27ohbsTg=
Date:   Fri, 20 Mar 2020 17:59:46 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] bpf: explicitly memset the bpf_attr structure
In-Reply-To: <20200320094813.GA421650@kroah.com>
References: <20200320094813.GA421650@kroah.com>
Message-Id: <20200320175947.AB1B920777@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.10, v5.4.26, v4.19.111, v4.14.173, v4.9.216, v4.4.216.

v5.5.10: Build OK!
v5.4.26: Build OK!
v4.19.111: Build OK!
v4.14.173: Build OK!
v4.9.216: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.216: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
