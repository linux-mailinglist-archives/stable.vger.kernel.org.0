Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987155B0E3A
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 22:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiIGUhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 16:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiIGUhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 16:37:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3758E9E104
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 13:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662583065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCs8gsbRUWvlhyvj5cjhNbRkewVX67viCj8epnpilrM=;
        b=eV7awr/y7EKSpkPNIsYT+ivcBiHv6ZY9WWalCCnqXti2V4cfkt+v9U+5mGSpd67XDOkM9B
        J3OelUvPDdHkK9fLcENPabobUYcd71HLH3YCJu9UbQY4i2yX6Mdum+vxKicMRwG5c8nhtL
        w0ORRvMeHr0ntuUqGdYxjBhNJ1C8HiE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-662-E05cNtqXPwGPrFTXuFkyNw-1; Wed, 07 Sep 2022 16:37:43 -0400
X-MC-Unique: E05cNtqXPwGPrFTXuFkyNw-1
Received: by mail-qv1-f71.google.com with SMTP id nn9-20020a056214358900b004ac7136c9a3so1034549qvb.16
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 13:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KCs8gsbRUWvlhyvj5cjhNbRkewVX67viCj8epnpilrM=;
        b=Cg4CDHyZgYeykDCivhdwpktgMo58TzZ6YLOtjjy/kY1R5FgMEONw5gmqs1ZAjUjxPZ
         Rrnzgr1YAxKNm1BseSMtAfL071I86rhvtbOPvtYIOIQevJ2Bahrt3SzicA1MIGBEEBX6
         4x7ceLHFtDsodKrz0gyIcnImC7M81cEwmW/F5qK61irhwj2Y8rOnjNlJW05Z26zn9Msz
         t1h5F1D0uPBSC96l3x1YTXkQLvT75HzhG0Fu+f7QkJjV+KnEUu1tgLmBeVWFiDgbGnEX
         dQDlz0XZ3MO1dSzRAvnDWsMiynNwn7q3hhUtAkHUYnZhlakJ6Jf6NrgWQugOBiLtA5Jg
         wgZA==
X-Gm-Message-State: ACgBeo2c9Txh2l7Qbx9MGVX8LkgVux3q3CpOe3Cy7SqdONHLuw0K4Bv/
        9OBWzwucZryGbxIB9zapNxbGPSjkA2CYEo3BX7R5qs8XU1dSQD4sy2+B/71Ra5pQW6iZFccYxVJ
        a4jDhv3+pio0xtXQ4
X-Received: by 2002:ae9:e714:0:b0:6ba:5364:d75a with SMTP id m20-20020ae9e714000000b006ba5364d75amr4164384qka.560.1662583063544;
        Wed, 07 Sep 2022 13:37:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4bGGzLIUcTJAiA6rhq1T0aGGF/LAmdhRPl+BFHLGa05CN0yGN8V3MHdUq6nCjwnjDFX6FQqQ==
X-Received: by 2002:ae9:e714:0:b0:6ba:5364:d75a with SMTP id m20-20020ae9e714000000b006ba5364d75amr4164377qka.560.1662583063338;
        Wed, 07 Sep 2022 13:37:43 -0700 (PDT)
Received: from ?IPv6:2607:fb90:ad9f:c6ba:ed81:2b35:f1ea:dc9a? ([2607:fb90:ad9f:c6ba:ed81:2b35:f1ea:dc9a])
        by smtp.gmail.com with ESMTPSA id 192-20020a3708c9000000b006b60d5a7205sm14492642qki.51.2022.09.07.13.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 13:37:42 -0700 (PDT)
Message-ID: <cf24580464a758ff58058d4f4826fd39d825befc.camel@redhat.com>
Subject: Re: [PATCH 5.15 011/107] drm/i915/backlight: extract backlight code
 to a separate file
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Date:   Wed, 07 Sep 2022 16:37:41 -0400
In-Reply-To: <YxiDU7mVujuKVqbw@sashalap>
References: <20220906132821.713989422@linuxfoundation.org>
         <20220906132822.225236433@linuxfoundation.org>
         <2bb97268e055b1dd3b3c01c4cbeb54446930e002.camel@redhat.com>
         <YxiDU7mVujuKVqbw@sashalap>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ahhhh, sgtm then

On Wed, 2022-09-07 at 07:41 -0400, Sasha Levin wrote:
> On Tue, Sep 06, 2022 at 06:13:17PM -0400, Lyude Paul wrote:
> > Were there parts of this series that weren't Cc'd to me via email? Trying to
> > understand why this patch would be pulled in since it might be required for
> > other fixes, but on it's own there should be no functional changes so it's not
> > really a candidate for stable.
> 
> It's useful for the patch that immediately follows it: 868e8e5156a1
> ("drm/i915/display: avoid warnings when registering dual panel
> backlight").
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

