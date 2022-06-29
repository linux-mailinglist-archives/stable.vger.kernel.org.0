Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EBF55F5C7
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 07:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiF2FjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 01:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiF2Fi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 01:38:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AE324F0D;
        Tue, 28 Jun 2022 22:38:58 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 32BF167373; Wed, 29 Jun 2022 07:38:55 +0200 (CEST)
Date:   Wed, 29 Jun 2022 07:38:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 5.4 57/60] modpost: fix section mismatch check for
 exported init/exit sections
Message-ID: <20220629053854.GA16297@lst.de>
References: <20220627111927.641837068@linuxfoundation.org> <20220627111929.368555413@linuxfoundation.org> <6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com> <CAKwvOdm8UiY8CsqNgyoq4MdC2TbBj-1+cRE+fWZ9+vVBxNZz_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdm8UiY8CsqNgyoq4MdC2TbBj-1+cRE+fWZ9+vVBxNZz_Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 12:11:50PM -0700, Nick Desaulniers wrote:
> Maybe let's check with Christoph if it's ok to backport bf22c9ec39da
> to stable 5.10 and 5.4?

I'd be fine with that, but in the end it is something for the relevant
maintainers to decide.
