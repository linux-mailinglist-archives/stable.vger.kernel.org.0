Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EC25785E3
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 16:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiGROzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 10:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiGROze (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 10:55:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D966DF6E
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 07:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08860B81611
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 14:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB9DC341C0;
        Mon, 18 Jul 2022 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658156131;
        bh=bU1+ugkGEMX+zZ4IkVXFkOJ4/N9jU7wX/94Jl1jRUKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZjEWoNOMjELv5q2vZ3FpaMPAk3ucl/qsATp2JxcQAGV8IJSVr7Hf4gNkOcyAsRGDF
         9jSTiEKdlX0d0w7Jf4JZ9KWyGQ+7NDIAMNqnckSTR0najvahuS1eQ0QmkV2LGh2EOS
         h2ghCkEkey2b0ET4hhUQM3AnHrc6AX5xDh0Vyu+0=
Date:   Mon, 18 Jul 2022 16:55:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabio Porcedda <fabio.porcedda@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 5.18 0/2] Backport support for Telit FN980 v1 and FN990
Message-ID: <YtV0YBzHEsXtOL5D@kroah.com>
References: <20220718132711.393957-1-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718132711.393957-1-fabio.porcedda@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 03:27:09PM +0200, Fabio Porcedda wrote:
> Hi,
> these two patches are the backport for 3.18.y of the following commits:

3.18.y still?

confused,

greg k-h
