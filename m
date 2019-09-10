Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835FBAE366
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 08:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404548AbfIJGBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 02:01:42 -0400
Received: from verein.lst.de ([213.95.11.211]:56472 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbfIJGBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 02:01:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3FFFD68B05; Tue, 10 Sep 2019 08:01:36 +0200 (CEST)
Date:   Tue, 10 Sep 2019 08:01:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH AUTOSEL 5.2 06/12] configfs_register_group() shouldn't
 be (and isn't) called in rmdirable parts
Message-ID: <20190910060135.GA30753@lst.de>
References: <20190909154052.30941-1-sashal@kernel.org> <20190909154052.30941-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909154052.30941-6-sashal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please stop selectively backporting parts of random series.  We'll
need to the full series from Al in -stable instead.
