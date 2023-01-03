Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2C765BB2D
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 08:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbjACHY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 02:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbjACHY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 02:24:28 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA1FB1F5
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 23:24:27 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 83so31315835yba.11
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 23:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=LqbIyQMx3P6UFuEQkQCuQiCa4kRfkdeY8Tcjm2d3cu19f+4HBQ/v4kBAAFEV+yE4jX
         wKN0GOe2jmnvir7B24rrIQ2xXX88o1q4YQIYYNnyZp1vhXIyZ+K4zgKdrjcy2mQPmDYO
         alwXJxxy5C/YRecngmwU+4p6AFar2RvUNTQ8ZwCBE2dC9JhSMZVOfnEvQMuLqy0kOrYE
         uI3uhu8NZwb/qUyMAiULcqyBY+SABP/7b//kDO4xRGfcX7ZeJB43IrWAK4uNB2uhnuey
         rjYRL35mn3H11jlk9jBBXkJzJFtawcpGvJ53SrKQwKxgvDJvnsAcEhLNbSM0H1fU+0lG
         3xSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=EYZdyIq19pEa8L1Dtwcz/qFac4fNncXqncsUsuQdp1QXPlKEkyQzP2zNmPvAXU/3CY
         ZWyFYask2nC1WfTev8EwR+2V22rTzazt24aF9I0gH68yki9M8jpGpcMB6a2bcH5tKJJz
         y+BTLwv5zLj7nUAwlKj8XkvCuXdkqjee0pn9yEsXolsWioMRJlLdPzTtehUkwgxeLaPZ
         NYthSYKqyGW/DhYjH/sWvFmjLWEvrt8X5UTwI7G0RsHaekWGNAIiQO+rAgPLsK+RPuG8
         a+K3dBkirZlPAd/tbuiXTjyAw4OUPOeke392nuKKk1QnvvRnbeZcHHbvQSOW/l1aq2nw
         y2xw==
X-Gm-Message-State: AFqh2koPFlMDUdtywARweI6WFvi1P0kPb82qggGHuEZvMTiwrm8DV5OI
        URiTsWKRWxa5lzbQPU/lwTqK2YPZsPL4hkVMrw05xCxEWhw=
X-Google-Smtp-Source: AMrXdXvPQQq2nDGSG21uQt7YZV8kSYWYbQhqEzED9SkazsmvQKGleQuyv8tAt1cJit4q+7i0wcT+LUB7dEK+fbrg2sM=
X-Received: by 2002:a25:7752:0:b0:741:7d19:89e4 with SMTP id
 s79-20020a257752000000b007417d1989e4mr4888760ybc.638.1672730666430; Mon, 02
 Jan 2023 23:24:26 -0800 (PST)
MIME-Version: 1.0
References: <20230102110551.509937186@linuxfoundation.org>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 3 Jan 2023 12:54:14 +0530
Message-ID: <CAHokDB=D4FYHw4b1bVRTQbZfJbpegvHP99NCOVaS=U_L2u9q9w@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
