Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B3E600008
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJPOvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 10:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiJPOvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 10:51:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14BA1DA66;
        Sun, 16 Oct 2022 07:51:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 872E8B80C82;
        Sun, 16 Oct 2022 14:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031EFC433C1;
        Sun, 16 Oct 2022 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665931876;
        bh=V/xVhzZcKriWTF7ef3fNM4E6qqbpen5/10aZ9OB+sT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UsI35QL2VoJZr4pY2itEXkyJS1+Zhfqxofb5kkLD/QnZXzyBTb+rAJ0rCmz1+TTa2
         E+Vq6o+iE/bTTQX2CBi+eIJACyEWInbJCvoRPqCs12CjXL6dOmn2NnFD5/8bKwwkmW
         IgChtayRQUicSdNJtpe8dOsPRMJEoCHPe7UbpsZakQCEoXw6jWuzKWzXIOIZt//6QD
         GwVC0UUEcNRS8s3RXDGCELi/l2bCy9s95+TpvaONby83piM9HbN+QS7FNxTTRdJqNx
         NcEVbk857NhhzDKB74ueHxhFuWwPNAT77sqyDZEDusSltb7+bUPpUJ3giQcQtkrnU+
         npXVDibWn2IAw==
Date:   Sun, 16 Oct 2022 10:51:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Simon Ser <contact@emersion.fr>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Lyude Paul <lyude@redhat.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        Jonas =?iso-8859-1?Q?=C5dahl?= <jadahl@redhat.com>
Subject: Re: [PATCH AUTOSEL 6.0 16/44] drm: hide unregistered connectors from
 GETCONNECTOR IOCTL
Message-ID: <Y0waYpSkyRRw4rVI@sashalap>
References: <20221009234932.1230196-1-sashal@kernel.org>
 <20221009234932.1230196-16-sashal@kernel.org>
 <0-fHhpvbGPf-w86Z7MGNoAe5uxHJy7vAdHcgjqqC2x8UWTZ7YY6wYORyxtrzDIf2pyPLt7z6dfFGOeUozmm7o0Qz0hpmhevj38g3Np3H1jI=@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0-fHhpvbGPf-w86Z7MGNoAe5uxHJy7vAdHcgjqqC2x8UWTZ7YY6wYORyxtrzDIf2pyPLt7z6dfFGOeUozmm7o0Qz0hpmhevj38g3Np3H1jI=@emersion.fr>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:31:19PM +0000, Simon Ser wrote:
>Jonas has reported that this breaks Mutter. Sasha, can we remove this
>from the stable queue?

Yup, I'll drop it for now. Thanks!

-- 
Thanks,
Sasha
