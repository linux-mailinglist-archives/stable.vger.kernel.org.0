Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5261F664D79
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 21:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjAJUbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 15:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbjAJUaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 15:30:39 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704847A922
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 12:28:55 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id jr10so4719136qtb.7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 12:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R08w5XqdPb225+ka82cm3H33ws9MRuWk8Mi6FerW9rA=;
        b=Swn9VeUzG1O4qUI5wxMakq3OMk72jn8ZQUSLPwIMHa2O6UPRR10VwCQpPg47u7hVPc
         +/S0rIGqSBE/9zsmp3y+iaXxH91E4hTPaXkpy0oY4mZXGDX7Ud+A7RUmXwMp+CSc9nq/
         22ndPRdiPkIHG/LhZqzkz3L/eC797lVgozUQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R08w5XqdPb225+ka82cm3H33ws9MRuWk8Mi6FerW9rA=;
        b=iPY0ufsne1usKyAUox0/QEvq53z5cJZM+53R5eFEsSUe74uYS3HhA/OjDRGtJADeFX
         0LOhaQqH16oB4S3GVubTZcjtOENQA4XXwJY9oTTi9GEnasUeyZCRDwXW7px6CTjEEFwN
         w9klUIr+piytHag+Wsw9mxPgWhep3GxS4HDZBUnFZiNm1MeQaqBKy8UogYItm6XrDAe7
         5PbT7+VK8dPeKIIf9hgOBxESDfGKxwoCxYUu9WTgsRQ9309F4Yd36JGg7cGefYFQgYdW
         yFud/tTapbrfetUeFL9NuEKRXexP9DmbWavQg4OePtUg2lrdggZNyScMCrdiYqjCDczL
         0lFg==
X-Gm-Message-State: AFqh2krGuKFXRSuBr62kh9RzW9CgNlb7xAa6XeLiLdMyhj5GzbRDOopJ
        8XlAzOLyUrKkKMV8XCF280cDAw==
X-Google-Smtp-Source: AMrXdXv8L9EFRvqX69qajD1gwqJ4bKpb4Wuz/gNhZY5D2epX934SjRuVVKihv1/0ZGubHDfvj1ixAQ==
X-Received: by 2002:a05:622a:1e13:b0:3ab:b012:f173 with SMTP id br19-20020a05622a1e1300b003abb012f173mr50540326qtb.28.1673382529091;
        Tue, 10 Jan 2023 12:28:49 -0800 (PST)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-7.dsl.bell.ca. [209.226.106.7])
        by smtp.gmail.com with ESMTPSA id em8-20020a05622a438800b003a82ca4e81csm364853qtb.80.2023.01.10.12.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 12:28:48 -0800 (PST)
Date:   Tue, 10 Jan 2023 15:28:46 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, helpdesk@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Larabel <Michael@michaellarabel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please, clear statement to what is next LTS linux-kernel
Message-ID: <20230110202846.hs7ksjylj5gcczyw@meerkat.local>
References: <CA+icZUUYrasObBwMQWae=+eAfUzvxc1Pk39QFz9=NXedWO41Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUUYrasObBwMQWae=+eAfUzvxc1Pk39QFz9=NXedWO41Vg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 09:22:48PM +0100, Sedat Dilek wrote:
> ( It dropped 4.9 from LTS list recently from [1] - guess Konstantin or
> someone from helpdesk did - so [1] is actively maintained. )

Greg makes these changes himself:
https://git.kernel.org/pub/scm/docs/kernel/website.git/

-K
