Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AA16EDA23
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 04:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjDYCJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 22:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDYCJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 22:09:03 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9144755AF;
        Mon, 24 Apr 2023 19:09:02 -0700 (PDT)
Date:   Tue, 25 Apr 2023 04:09:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1682388541;
        bh=6wGx90z7Z5ohAojWLBz8WU1/frXKL5fIPvAQ/Pdf5vY=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=ll638CkgRhb6Zfwb8Gmgyp3c5t0XnpbuksMMgYc2ugdKV4fHoQnLSDJxxc+H2EP7z
         0W+v0fe0mUGvIC7v4coUt2053UgMco35fFNSWzn+HUpkuYg0wi5C2hJTs5tZ25AXO7
         kv7Dr25mvYchoJLlpyA4m6qzgdwVa3U8aNS4Fh9Sc1RjgOAdndQDjC6fMTMq1ycNdp
         +6BQv4Jh5tddgvCgiIotzL4apxTyLFktBxC+alS9ynFmBUnDt/ZyzuOJRCjHeW449L
         GOy7JbOVVo1i6PH7nepiB+l0iC/i/fnIwkLtzFJPvXt4OZZFOO5cfZIseCqIgonYKj
         I/tiPSgupyBSQ==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
Message-ID: <20230425020900.GD3798@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230424131133.829259077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.26-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
