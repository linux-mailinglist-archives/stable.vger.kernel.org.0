Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05286D56E5
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 04:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbjDDCth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 22:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDCtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 22:49:36 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96C21FD3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 19:49:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso34731467pjb.0
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 19:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680576574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qL5dNmvrY+ZBnMHEpT8PD2ZaexlXJdeNew9ThJdoAL0=;
        b=F1OlblV0g8Uk9LAvEq+mXbtXih1jSLq0wnZEg4eqHar09BL8VB2lt5G9UMg02ey0/a
         yqghUp0N26+A1U7egSW5do3QZ+oOXaz5eif5Cq2f4jwbL5xA5H6qr6R0hMkSBKBnQZY1
         U27NgUzqmiaPccMAOtTKdAq3E0Idt1zTr8FfDU7EUE03HlVf2FFTKEMShq+wDb0dBtLi
         EvmPICqIF4q5BdDDM8LNJ+cjvSOlRNMDHR7rQkWoVNRE2vXjtiWq98p1oCqbTxnW9Bgs
         Iyzlg4rG378B4Nf/EwP+Uouvmb5KOzV+VEeYpJwFjhzlSj5K7xGk8eEmeH+T7xDmPMlM
         TVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680576574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qL5dNmvrY+ZBnMHEpT8PD2ZaexlXJdeNew9ThJdoAL0=;
        b=DBAsJbEP1Znr+K45NG820GBAczmoP7pF0T/xcDTW3sEOud/RN4XXOp6FdUQOk+fb5K
         TdB4TGurrj4vlX3TPqpDR/y6x1Xx+D2QrXMyGX2m1w/MxYmN8E8Jd2BH14iEE5wJum2/
         nTauTE3kvfRS8CemREnM0Tv8F0U1D5C011VJMtxKzFmo5i3dAPRNoVgggP9YPkKCyEY8
         gUi1M0/K2KV+MleSyNJnvHlgamjDvF31yhhw58WbHHumRLQmtyEVh4JKEjvkksH+XYVF
         6ZJnfWUP0DSSejgIawYFbKHH2L5HQFS18tfIMpBLkvJqPep01scVCwaKDhoPjY0DO9uv
         wG4A==
X-Gm-Message-State: AAQBX9dXZ+T+Nhp9dh9AhQjGSzH21VoyYzY3by0afCPvvGPthpxl33cK
        JxGNHCUpp0abjDkx+wL5J2k=
X-Google-Smtp-Source: AKy350bOjbP3Ql+0uOe4yVhaawJR8JoMav8yC9fq+tkx1WHyRx3PNZuNhMHnxk9j9swSrkexeMv9Ow==
X-Received: by 2002:a05:6a20:6a04:b0:d9:7a97:a7b9 with SMTP id p4-20020a056a206a0400b000d97a97a7b9mr18569640pzk.6.1680576574263;
        Mon, 03 Apr 2023 19:49:34 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id c7-20020a656187000000b00513468106d8sm6665398pgv.1.2023.04.03.19.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:49:33 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id AB5D1106782; Tue,  4 Apr 2023 09:49:31 +0700 (WIB)
Date:   Tue, 4 Apr 2023 09:49:31 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     juanfengpy@gmail.com
Cc:     Hui Li <caelli@tencent.com>, stable@vger.kernel.org,
        Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7] tty: fix hang on tty device with no_room set
Message-ID: <ZCuQO3A6FX305KTJ@debian.me>
References: <1679019847-1401-1-git-send-email-caelli@tencent.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7CHwf1ekuqcFyMzO"
Content-Disposition: inline
In-Reply-To: <1679019847-1401-1-git-send-email-caelli@tencent.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7CHwf1ekuqcFyMzO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 10:24:07AM +0800, juanfengpy@gmail.com wrote:
> We have met a hang on pty device, the reader was blocking
> at epoll on master side, the writer was sleeping at wait_woken
> inside n_tty_write on slave side, and the write buffer on
> tty_port was full, we found that the reader and writer would
> never be woken again and blocked forever.

Where do you find this hanging pty? Seems like the wording makes me
confused. Maybe you mean "It is possible to hang pty device. In that
case, ..."

--=20
An old man doll... just what I always wanted! - Clara

--7CHwf1ekuqcFyMzO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCuQOwAKCRD2uYlJVVFO
o8QjAP9CaDwdue6PCTTPxqw9QVwBSXhN+aDyZw/fPFfyV+mKFgD/XVUKGaD+W1hD
bIoAiCer/3wUWwCCIn/awyYHZqojUQU=
=YYrO
-----END PGP SIGNATURE-----

--7CHwf1ekuqcFyMzO--
