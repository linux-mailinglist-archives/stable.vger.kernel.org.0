Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9299676DC0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjAVOnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjAVOnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:43:51 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE831BAF3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:43:50 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso4927048pju.0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=safYeVgmMpwkmK24Xn91tBPNk2xb07jYdK3n8dECRg4=;
        b=FwMr9+uAdaJHp8/62+yfd6xYN7xlx7QPzxdprbVGA5wNXWuepsYIEivPQnMzSqjjXF
         kZI+rUEoaVthkipgD17FZUMe6SHJxrEe2us1YRmVW+7aty0n7mFGmGPsAOaKVzGySF0E
         EKPGNmWqkmrtqyxwDaRTfqP7mhAcMSoJauW4ty00IeuO6TOg+yh00Iuxwo+lqvS2MQ1K
         Y97gJLjyZ5KM1ptcWlN2CJr1C983GuV2fnlclmDsnSnI8SWNvgwWc3IxnDw3KhxlRL1N
         sFYrf6YCXMtVtRXvSOCzz/ROqS1fDRSMAPUCfOKzTYDur23KLrWU4MOfqJMapPIQsvRs
         tH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=safYeVgmMpwkmK24Xn91tBPNk2xb07jYdK3n8dECRg4=;
        b=0u1tMdFc2t++wgE4Fnvck1lJzvzrlSOlfeDhfFaA9Za2no9KJA/tLE+5WX89I+T1EP
         q2xenPX3I0vfqdlBVdctQmiXzCSEIdvwmcYD9z3bHwURwU4vQFKLqV6Xk2GyzQ3MjwnW
         Hr6au0KsKfAiv0mDNrFdokgel2jNclz8af+qq2J4vRfeLf3SC8vA3Tcxt1pPEfQVTRNg
         TeoA9Cmmot/9uwo/xvQ4qM5e8FXu0ScjOmaWtewbV2KGLmVBvhuCcUQ93cHvFkjhG6/j
         K2HV0cAxNxo3CrmYAQN3dePGX/rBYVPD/fM2gMLeuOMedxSmTQK1EEGZNQUl4y7OQiW8
         3a4Q==
X-Gm-Message-State: AFqh2koSAKHsxHyacv9ONR36cZKfp6duKTIBDQzSZtHbby8g8yK4enuR
        kMTEOTHC/SgDcPjgNJGbGH8=
X-Google-Smtp-Source: AMrXdXueVpDdoNtNbjSa1rbtvdZeiOgXbY5X0NnKLXqJSTtPK+hRwzAi46jXeSNIJuoGesKhIsDKBQ==
X-Received: by 2002:a17:902:da87:b0:194:df0d:1dd9 with SMTP id j7-20020a170902da8700b00194df0d1dd9mr11780226plx.19.1674398629930;
        Sun, 22 Jan 2023 06:43:49 -0800 (PST)
Received: from pek-khao-d2 (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id y12-20020a170902e18c00b00192a1dfa711sm23650639pla.258.2023.01.22.06.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 06:43:49 -0800 (PST)
Date:   Sun, 22 Jan 2023 22:43:44 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.15] cpufreq: governor: Use kobject release() method to
 free dbs_data
Message-ID: <Y81LoGq6B1wCsx0T@pek-khao-d2>
References: <20230120042650.3722921-1-haokexin@gmail.com>
 <20230120214032.uzq6dgpzhfi7quol@oracle.com>
 <Y8tE1fkJN5BvhWym@pek-khao-d2>
 <Y809uFh7F2s7/GN7@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v5IE05IWiQAKvDpI"
Content-Disposition: inline
In-Reply-To: <Y809uFh7F2s7/GN7@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v5IE05IWiQAKvDpI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 22, 2023 at 02:44:24PM +0100, Greg Kroah-Hartman wrote:
>=20
> Please submit a working patch series that at least attempts to show you
> tested this :)

Apologize for my negligence. V2 is coming.

Thanks,
Kevin

--v5IE05IWiQAKvDpI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmPNS6AACgkQk1jtMN6u
sXEoEwf9FjzbzcdeQAxFQdg38Kd4qoZe3RZhNDJfDI8/wba0hJydcWBW6KQzfSBc
8P/0kiq5u+BdT37D0rSa0bLswbhtEL566RLxI5P+f3h95E32zYcCHmPn2mWXmJ9W
oePMDVYAU3jtiBcbcC1u8/moe00ibnnmCXjZhg45p79J+FgWf3MIEvM1zOKtQxvd
2UcoQre3HOOun2AeksN2UpGjAxA83ksO2C42SDuBbtKEEaVO8W+2Q61UHGJmDM+/
psQWvT0r3le80a6Q0TXKQyOhmMnZeIysHjdH/N2ZQlEzzlU9cMiGHRNfgOLFWR6p
7cyxCyWy7toc2KUP5f+fMrTtNPvjBw==
=e3/g
-----END PGP SIGNATURE-----

--v5IE05IWiQAKvDpI--
