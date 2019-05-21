Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E077324F3E
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 14:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfEUMv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 08:51:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43564 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbfEUMv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 08:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=FeDWO975fNC3Rwlp1Ik8IumWR
        KElWZeU1FzJFkbHDOrfiz4kprdOImDn1SnpES/LvZkL47QoeeS928tvMlNHtFxLNqacnWa4pUiRBZ
        N4/qAAn5bOcw9POmiVKbzP7b5oJ4Ta/dbyQ7Xstfn5wS8M9VOUIU5N4dWzSbZKZK/BolPttr14R47
        qhGoKWpDxPejsZo3Ruwq4cSICjl1nMu+dupmhpkVxDUI7B9FXdN3BNkqqhYeMJAqyOqTGCSsJcxv2
        GlN+wMlHHpG6+QCevouBZKRYhvS14WFh6JQmebgLYMgfdgXAxMSY+YLEwnH9BK6OQwdAvGKLfC9KL
        8wInl9RsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT4Eq-0007jp-Fk; Tue, 21 May 2019 12:51:28 +0000
Date:   Tue, 21 May 2019 05:51:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, gavin.guo@canonical.com,
        jay.vosburgh@canonical.com, kernel@gpiccoli.net,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in
 generic_make_request()
Message-ID: <20190521125128.GA16799@infradead.org>
References: <20190520220911.25192-1-gpiccoli@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520220911.25192-1-gpiccoli@canonical.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
