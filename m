Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AD353FA97
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbiFGJ6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240456AbiFGJ56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2564B52E6B;
        Tue,  7 Jun 2022 02:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2254B81E79;
        Tue,  7 Jun 2022 09:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00BC34119;
        Tue,  7 Jun 2022 09:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654595874;
        bh=n/7TGW3zb5JaH0sCCeCStqtqabbwxScT5E3woYbIHFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FPbRHo55ZbU4iKm6RP2J9F1eyYYXtU0MjQYPSwTfehS0W6Lx1ouOXW9MbjtNYHEn3
         VTfg53xIEZqw3t51L1rF18zWEKLkL+4IOE7NY3di4oe7XVs0Wc4GwaDquWJRtIeMD0
         Cedv1A/c8xIl7NXfn57qaxzvNIuXznbESxE/b04g=
Date:   Tue, 7 Jun 2022 11:57:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 0/6] bfq: cgroup fixes for 5.4 stable
Message-ID: <Yp8hGR3L1G3ZMbau@kroah.com>
References: <20220607091209.24033-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607091209.24033-1-jack@suse.cz>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 11:15:08AM +0200, Jan Kara wrote:
> Hello,
> 
> In this series are BFQ upstream fixes that didn't apply to 5.4 stable tree
> cleanly and needed some massaging before they apply. The result did pass
> some cgroup testing with bfq and the backport is based on the one we have
> in our SLES kernel so I'm reasonably confident things are fine.

All now queued up, thanks for the backports!

greg k-h
