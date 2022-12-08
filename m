Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB909646731
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 03:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiLHCoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 21:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLHCog (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 21:44:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F382154354;
        Wed,  7 Dec 2022 18:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RgW1DCuq+lbWReQD6T0I79Mf1D+OEQXuPYzr5eUbe4A=; b=r2JHwqeZeDc0z6t4qVHOdSQCHT
        rh2KbvwCmv7qnKXneE8ohfxnznX7OLUBcQ/gRyrd8cVI+xsseo7S1KvXVsHGBGVrbACwxyLfxvvy5
        bj7QNkDw3YAv3M7fTS1NJBBF6p4+U3zv0ja/yKWLNqlIfCX68d706B9syo1ZdKE8aZ0gdE3TKUyl0
        V66xmuHHKloHXETm4wikHsimu2QZffjJoSB7t3DQZ7BZ2LqdMRseyINOD4bHPBTXe9doDvjcAo8os
        S6zkVP+aXNZpT9zT453l/0gUxAmGTboMi1/pPpFAPb7ZUOrXqfumyMT/hTp/USqnBWwrnZJOd4rTD
        cViAH5wA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p36tk-000UPb-VQ; Thu, 08 Dec 2022 02:44:32 +0000
Date:   Wed, 7 Dec 2022 18:44:32 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Petr Pavlu <petr.pavlu@suse.com>, prarit@redhat.com,
        david@redhat.com, mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y5FPkEgEbDlVXkRK@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y45MXVrGNkY/bGSl@alley>
 <d528111b-4caa-e292-59f4-4ce1eab1f27c@suse.com>
 <Y5CuCVe02W5Ni/Fc@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5CuCVe02W5Ni/Fc@alley>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 04:15:21PM +0100, Petr Mladek wrote:
> Reviewed-by: Petr Mladek <pmladek@suse.com>

Queued onto modules-next.

> Of course, the ideal solution would be to avoid the multiple
> loads in the first place. AFAIK, everything starts in the kernel
> that sends the same udev events for each CPU...

Fixes go first, *then we can address enhancements. I have some old
fixes I can send after htis is merged. I believe folks have others.

  Luis
