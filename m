Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FD555195
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfFYOZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:25:16 -0400
Received: from verein.lst.de ([213.95.11.211]:35355 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbfFYOZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 10:25:16 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 2EAFC68B05; Tue, 25 Jun 2019 16:24:45 +0200 (CEST)
Date:   Tue, 25 Jun 2019 16:24:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jack Wang <jinpuwang@gmail.com>
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [stable-4.14 1/2] block: add a lower-level bio_add_page
 interface
Message-ID: <20190625142444.GA6993@lst.de>
References: <20190625141725.26220-1-jinpuwang@gmail.com> <20190625141725.26220-2-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625141725.26220-2-jinpuwang@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Why does this patch warrant a stable backport?
