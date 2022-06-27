Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C955E10F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiF0Jz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiF0Jz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 05:55:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4318863F0
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F128DB8108E
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 09:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80390C3411D
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 09:55:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lfUt2dVO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656323721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uMbEq1wX7GoLRVGETNpLu7dNkEenpWSYfyBmT+ly9ns=;
        b=lfUt2dVOjOIhHIHv5SfmRfGPBGev+FN+Ss5cnJYtdrRqPLWoKSwjJccJ/gDr+0S8O/9V5d
        2K6RyIgmlyjs8DNT6gpXoVTc3k0MFQqQn3RRJBmJE3050fkK0sSGgmEDAgxaAWrQhwxS2Y
        pKsjnt+X2L5pMYum93YW1KBv7OY3YVM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4d9f866b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Mon, 27 Jun 2022 09:55:21 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id p14so5665216ile.1
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:55:21 -0700 (PDT)
X-Gm-Message-State: AJIora8ko0yBa8UVypAR1JWkFUvOVrB9ATeqQCUI1jwjKH+ttxN9u7t4
        dq6eghY2wx5rlgPJiJuffyeABwcWuLAI5jS0DPs=
X-Google-Smtp-Source: AGRyM1tqoyh8atbEB9Sv4e3HLXlKIl8w2AzWoy7QhI5ncWenmvTEOz8cOYomTuw/0DtJgDxRcxvqjBVnCD29eYpqBmQ=
X-Received: by 2002:a92:c261:0:b0:2da:96e4:ee33 with SMTP id
 h1-20020a92c261000000b002da96e4ee33mr2121056ild.42.1656323719975; Mon, 27 Jun
 2022 02:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <1656322983223152@kroah.com>
In-Reply-To: <1656322983223152@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Jun 2022 11:55:09 +0200
X-Gmail-Original-Message-ID: <CAHmME9p1QaJZGd3Q8T2CLQo=+H=_-Zgu_isxiM02eB32ZgeFUA@mail.gmail.com>
Message-ID: <CAHmME9p1QaJZGd3Q8T2CLQo=+H=_-Zgu_isxiM02eB32ZgeFUA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] powerpc/powernv: wire up rng during
 setup_arch" failed to apply to 4.9-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I started to backport this but noticed 4.9 doesn't have the darn
wrapper either. Christophe/Michael - if you want to backport this, go
for it. But I'll leave it be.

Jason
