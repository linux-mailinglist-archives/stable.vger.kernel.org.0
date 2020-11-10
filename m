Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A692AD202
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 10:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgKJJFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 04:05:39 -0500
Received: from verein.lst.de ([213.95.11.211]:35177 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729981AbgKJJFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 04:05:31 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9884F6736F; Tue, 10 Nov 2020 10:05:28 +0100 (CET)
Date:   Tue, 10 Nov 2020 10:05:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 53/55] seq_file: add seq_read_iter
Message-ID: <20201110090528.GA23535@lst.de>
References: <20201110035318.423757-1-sashal@kernel.org> <20201110035318.423757-53-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110035318.423757-53-sashal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Should not be needed in stable in any form.
