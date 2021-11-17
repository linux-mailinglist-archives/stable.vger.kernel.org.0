Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FD545409D
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 07:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhKQGHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 01:07:40 -0500
Received: from verein.lst.de ([213.95.11.211]:49034 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhKQGHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 01:07:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0D6CC68AFE; Wed, 17 Nov 2021 07:04:40 +0100 (CET)
Date:   Wed, 17 Nov 2021 07:04:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@digitalocean.com>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] fs: handle circular mappings correctly
Message-ID: <20211117060439.GA1822@lst.de>
References: <20211109145713.1868404-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109145713.1868404-1-brauner@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
