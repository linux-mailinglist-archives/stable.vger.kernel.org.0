Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678724D7AB7
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 07:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiCNGTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 02:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiCNGTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 02:19:51 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E372DD6D;
        Sun, 13 Mar 2022 23:18:40 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E67468BEB; Mon, 14 Mar 2022 07:18:36 +0100 (CET)
Date:   Mon, 14 Mar 2022 07:18:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        syzbot+b42749a851a47a0f581b@syzkaller.appspotmail.com
Subject: Re: [PATCH] block: release rq qos structures for queue without disk
Message-ID: <20220314061835.GA2974@lst.de>
References: <20220314043018.177141-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314043018.177141-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good (for 5.17 only):

Reviewed-by: Christoph Hellwig <hch@lst.de>
