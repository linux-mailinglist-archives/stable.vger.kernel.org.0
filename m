Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF915B034E
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 13:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiIGLlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 07:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiIGLlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 07:41:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53137D78E;
        Wed,  7 Sep 2022 04:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EF4CB81C3A;
        Wed,  7 Sep 2022 11:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B861C433D6;
        Wed,  7 Sep 2022 11:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662550869;
        bh=z/suL+NZgFFX1QTw93zmzVaDGJv13W8Xm1l3sOANllI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IbPg+OuIpOdXBg5AB2eEm/a6oeI1hvJD4bDTgvWDZsRfqKvgEn08zbfKSgphldkPQ
         iRXLPnfZFi9227HR72L9lLP2kxTZyri2qyuqJpY9dYpEk0zw1opGWvZ1uGOqjZX1e5
         sQSzT9tixPzk5iUiq8hT8orcMpyxr4DW7QAiREMbYngwfT8UUCo5INHDk2En+/blrZ
         rqtfK7MnJtB4/Orn2TLKcC5QHUE1bejKB0JwNpr6Jn+yaqd3i1gkP7VdwJCNngiWM2
         uQdeKtvx4Ck7ePxGf9+HqC6udSkUwtrbQtTw3o+8YI7TmI7El+lMbVcWChVCWEybP6
         1gVGvVJJXIvXA==
Date:   Wed, 7 Sep 2022 07:41:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 5.15 011/107] drm/i915/backlight: extract backlight code
 to a separate file
Message-ID: <YxiDU7mVujuKVqbw@sashalap>
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132822.225236433@linuxfoundation.org>
 <2bb97268e055b1dd3b3c01c4cbeb54446930e002.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2bb97268e055b1dd3b3c01c4cbeb54446930e002.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 06:13:17PM -0400, Lyude Paul wrote:
>Were there parts of this series that weren't Cc'd to me via email? Trying to
>understand why this patch would be pulled in since it might be required for
>other fixes, but on it's own there should be no functional changes so it's not
>really a candidate for stable.

It's useful for the patch that immediately follows it: 868e8e5156a1
("drm/i915/display: avoid warnings when registering dual panel
backlight").

-- 
Thanks,
Sasha
