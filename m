Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FCA2218D2
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGPA1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgGPA1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:33 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ECE62075B;
        Thu, 16 Jul 2020 00:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859253;
        bh=sH7HZ/hiQ6QZF9W5U008uEn7gxw0DgoaqhS93fgxyfw=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ptUOxybMH8P6psxTIde0HVNyMy8dq4g0my4AdtXPwRf7dlm9DodZM+h1axGA9YX+7
         tcpruouj/2BJc9rLAiYBfaqclR092Zm/+eVBy/bAnvtar6i2oZj3+m2iRN5hRFwfTh
         n3Ui9cjevr4pwrXbeJDuiZFzZmJYGgKPTciB7gEk=
Date:   Thu, 16 Jul 2020 00:27:32 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Stefan Priebe <s.priebe@profihost.ag>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/3] fuse: ignore 'data' argument of mount(..., MS_REMOUNT)
In-Reply-To: <20200710115805.4478-2-mszeredi@redhat.com>
References: <20200710115805.4478-2-mszeredi@redhat.com>
Message-Id: <20200716002733.3ECE62075B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c30da2e981a7 ("fuse: convert to use the new mount API").

The bot has tested the following trees: v5.7.8, v5.4.51.

v5.7.8: Build OK!
v5.4.51: Failed to apply! Possible dependencies:
    7f5d38141e309 ("new primitive: __fs_parse()")
    82995cc6c5ae4 ("libceph, rbd, ceph: convert to use the new mount API")
    d7167b149943e ("fs_parse: fold fs_parameter_desc/fs_parameter_spec")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
