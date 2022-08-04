Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19FD58A342
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 00:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbiHDWYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 18:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiHDWYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 18:24:49 -0400
Received: from sonic310-25.consmr.mail.ne1.yahoo.com (sonic310-25.consmr.mail.ne1.yahoo.com [66.163.186.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98738268
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 15:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1659651887; bh=PcTfW0raGYIAkffs8D85wUFLoXDlSJu3kgSidiXhssA=; h=To:From:Subject:Date:References:From:Subject:Reply-To; b=q1F5EgQVymqqJJtTBMgufmEiJWvtB7rUj3YergNk73CZQB6VHsR2mm3XAWUgYmePRk5b0thCv2b6zIs+90T0lidwIfLN3rLi8Em1GdEk9kfesvkns0gcepwtYvOfkQRZvZUKEkouBbrfCwJk5fhEG9VaqCSR4v74WsShFP2Q5NTbOAQlG7TbIx2Gnkz8rmny9mWBdTZc+FvLHOPeJTC/3u4zQ2HmithBhFY7iEACMyYA6cmRqJfD8l32i3BsTyrfuHQP0WshwDHq+8ZjRgpR40ix/sjB2yZh+X3JiuemWVRo94f3b+Gf5Ld3CdVS8cP96q01CXJXWzqcDXGKDMCmTg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1659651887; bh=5EJ+a/5KNBs7mGReHbZ29Uy2aNQuxUd9SFyAVL403BH=; h=X-Sonic-MF:To:From:Subject:Date:From:Subject; b=oZSBR41qSjAvx+q2tChRppb0Q5lfrVuvY2RZrstPcO4lrTTYc/HYoMXLOWvN32XhwRRKKLlx0mNxBJZ/JYDttTiwkehSqDi6L6Sa2sEeA5xGahHSxocZOzQD/Lur2uQXf78UQjQlASpt0dRzHVAXcZpZieWn3rTby9vMfLHlcBOWSWuwdxnfy0bTbXLDZbO1mGkZFee/+fTkRdTAf/TP3KgCz2P0eICjAB9bc8BNdqs/8GQ4x1vDJl4qoBlK8LjM1wVYyjAz4RFXRIsoIzV3mkQfq0qVtBjAOgGWUt6qTvGMzHIAcilEH54ZgnB0F3oMSn1Kk/u2jd/wSxDZCimRJQ==
X-YMail-OSG: ledymt8VM1lljCkOrqN4ixgVUb156zXFBgxwyYmVw.k..RKZgDjB5jrwe4YsrU_
 zph7zVb2GkDrJv1K7TOPBiyV8HwGwAkPP_eR6.4w.Nbpoo1IgGpBDi_uqyRBEedqBWf6wyooxEQb
 PYcTszmjMxOKx1ptTYD._t_O0.tLIWrFwkKQfYHAn6ih46K8_O.5FQlnJ6_k8yZGw3nyN1hO464l
 1_YXmSzs_BGmUMkHj2I30r4R1GNEG.Iqmm2eRtSzI.cOAyNFTWMKJJctB79X_cO5O6zL79Y_PHee
 W5q8LfTrUnXQrAtRYndKzRzA.uEuKN_Y4L6jRaO0F4xcjrGCWn3T11QhxyIwd_ETTrag6wXTfrok
 d.1SiEEWOOJIu9I4ucpH74sFw4W6isTYYDWnyoSQc.ndDs1BLaHizTKO.SZUeTRs9meextJ4DzFz
 InCeeN7nS7.MP4lyGzSwKbkPFogAzb.Rw6Dxrsof8jGW_K4r1mW2ixeEULaLgS7rd.XOmPTOuecO
 Mkceaxw.Gns3TwdjjFj_3XneyshHcmBaXANDy40aa8VL56tVC_Z1H8IWcg1SwZl_WVrWv4mW7Sd6
 dUa8VrQiFCJ.nll_AugbHqpu6bTAAJSaBlld6lU7Soqx5raaFVeQTtDyjsmOHlur1yPBVhrYXdpO
 xJk.PEgowKWmFBtMPv7dOv_zQFmPopPxPqTkpfrJlnBuxKvxSRnccbH9LQPjsqsiDAxk8GYdu0oq
 WpanTZ_JXGFburVmL.P2_74eNe5yzsGBpci2DNaGb0.GPjl8_PPgBslt4_QQY6.WujgoYuPUKghd
 CaZGctzI3hllO5n7Q44gPkWc0c6RSvJ.39nziH8yoqSOHFwAcC3ahgjit2PkwVi8emKZBZoAX3xs
 rgSAr..ebdvNazcIf.2o9xG3rSJz.DGTR9jLjyJq9C.vtSheZSblPHSkazr7JNmRY4eShmETjGQ_
 CYTBzkFtUhMr6sq2JA_amQn.OQzPikvwHzhQx3JbcvosyTRGpDxAc309Yo7P868Aha.nJU_n07_b
 EQbSQvXTgUAaZRPk.zSzwf5XWbRkVPb40iVYEPcNHI.wFMp2Pt5AJ70oMXRs081yCFtaild3jtkb
 bmceZXtsCmtds1_hvPWzwW.CI6LqQI5TDEZJDhm8q.SDlmbr_LPXd68YoNGLel_65K4n43EyHh8g
 yGFiljqtVjhZmHRLf59vg8wj7HbgThZwtt1aVR7vztMigD5EfIKa5RvWRPgH23mHCLaZ.JNmLSw1
 ebemA8Zq0w_qCvA82cquDmXKMIJkHgjKnUYe7HqV8jkcbrr_NqP6tEshvL1Ajo3xVmq1Qd0lBYR3
 b9cdlj.6ViRcNIVRQANJBXFGSRN2bnnrVsaJpI3iEtiek2poDImDvO.VsH18GjqYBhXmxWWdzVCZ
 5O9bV1mk53Uj7pQuBzNoknn5XGJQDsy46G27lk6rTKZugggCLzPtUrWD_rWwyhOUWzVlCak1B1bm
 fRnbqIpxu9AJJ9Zu7lQ5BuaN30LIS6QmKqXe3qnPZ.ZCIUnOtTfu6I9QySurKv7fi3Pa6dgBmRBb
 jKf7fELX_1ChbcevZVgrGeO3AxEqoLXK743C.WbjRKuUZYf.N2Bof5qjLDjPbGjFPns.UPs3rIhX
 gvj66zEV2_r_5H.xLO3dZHhafPAETYyEs_09j022lVfn4XcZx6QkdhtUvfSKhadlJ0GSfM.HBY4b
 F0aPFvBQnIlcd2Y0z8CYobVskHK3TZeM_8zm7nKIzvHQy7WVIDiQ9e3Buvapi6l5QfqjjSwhoy6t
 _2XCZ6rVVBpF8peM7M8O8.yUUPrG16jFYSDnsF3xwIEmEtVBr3Z..h_Utc2bIWgE.ic0NLedgV_0
 wTVK5QkguAwpyvxF9loUaedphI8Sq8rfE9269n_IXZS1GysYsAq.8vu2nbuRKAyEQjyU0vyqwuwG
 Q2nusuqFufl6Nbttwx.fnAUYaWx8TjHcKINFaIr3Jj3GnaBG_u6HioqoHI8TiGZ4rLyrc8cka315
 WKAbYCvvEC2UAEuFAkI_ngYWRtwmXmo1hIEHUj8WZIrudUAkmf5rMNFzvI7wWDpw4ZIcfr10dFpE
 43Dy_rGA5Nz9FU3ZGswbRRH4h3skU1T9UTE4FXWoLgjWZ8ZK.sL8uE9dB8HuKdKEgSKq2N_U7JMW
 vq.VRMtmJQqRNIe2Tc2nR1maAuWMKM0EbZo94zK0uix.3yz.N2N6nVtsGxsX0G95VNLmhQ_zkT7p
 imM2vCpQ5lWhA8A--
X-Sonic-MF: <augusto7744@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Thu, 4 Aug 2022 22:24:47 +0000
Received: by hermes--canary-production-ir2-f74ffc99c-5fxhh (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID c5f21c1a5b3e2549f65aa354721acb38;
          Thu, 04 Aug 2022 22:24:44 +0000 (UTC)
To:     stable@vger.kernel.org
From:   Augusto <augusto7744@aol.com>
Subject: kernel issues
Message-ID: <c27fc190-306d-c648-ea3a-e52839da2160@aol.com>
Date:   Thu, 4 Aug 2022 19:24:23 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
References: <c27fc190-306d-c648-ea3a-e52839da2160.ref@aol.com>
X-Mailer: WebService/1.1.20491 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.
Thanks for read my message.
In https://docs.kernel.org/admin-guide/reporting-issues.html has 
information to send message to stable@vger.kernel.org.
I see an problem with BTRFS when using dm-writecache module.
I wish report that bug issue.
Where is the correct area to report kernel modules bugs ?

If stable@vger.kernel.org not is the correct email to ask about my 
message please excuse me.
Have an good day and thanks for reply.
