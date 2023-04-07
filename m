Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707186DA9BC
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 10:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjDGIJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 04:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDGIJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 04:09:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCA68A6D;
        Fri,  7 Apr 2023 01:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=u92BVdgQKegL160NbY8VQjrkAm
        FthmCgSAk57TlSJXN246SaiNK2vFGb4hHkEj950B4r8dlHMAUKp9AbGj1xRMTh2Af6eJ2dFqfOTzM
        z2AfxEQG43NGWlWyR1LF97r0DjaH9wew6/C2T1Ussf30U6+H2fIb5GNXY/sXQcNZmUg0m7NhGqF2I
        dxRMtwXhs6yjCi0w2fo2cTMtePsBgzcq0a1Ig+ZhmrqT1/tiyaf5keLcwFRHIzbuUilhwlvWvqC2T
        mTGgHN6FH0OUq15vDekea+pl392Pqz2fiBcdEYpGNtD/hJejR9gSE58fqHmZJDwLv7rNVe59Jghet
        7VNSI1Ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pkhA4-009RsN-2O;
        Fri, 07 Apr 2023 08:09:32 +0000
Date:   Fri, 7 Apr 2023 01:09:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+51177e4144d764827c45@syzkaller.appspotmail.com
Subject: Re: [PATCH] fsverity: reject FS_IOC_ENABLE_VERITY on mode 3 fds
Message-ID: <ZC/PvPK/e0j5mZ7o@infradead.org>
References: <20230406215106.235829-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406215106.235829-1-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
