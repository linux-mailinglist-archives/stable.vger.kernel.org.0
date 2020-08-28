Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2802A255A42
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 14:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgH1MeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 08:34:23 -0400
Received: from sonic316-11.consmr.mail.bf2.yahoo.com ([74.6.130.121]:36755
        "EHLO sonic316-11.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729367AbgH1Mdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 08:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598618021; bh=vSZ7gQ8F13hDNYtYk6t77g8qrdmtAY1S6LJUlA/r/r4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=KKR6MC2cY5cdBRdGS38p5mDH8B8gJJ7KR++U8EZYyankaqCch44W7hqKgPHcjfihsPLDev3xPDydVuQ7kBzvgNf6gadpFVVRtYvga/7clAfkwnTZS/etjOJUYO4DUoGAKqV+xDJcB2ZwN3zZqh1j+pzgBMPHuYNPe5QkFGOQD/a+bEFhZKyvDz/uli6WOa+h16hgAWs7fHb8ur08u5PdooUBisITMoQiDcIXhokYrhZqBvvkjlSzCll62k8Vb86jQ6yEiLxQYYSHf9+HUbXIhaA5dvpyYWo+8y4USA362YzmbUPxf6C57u6ZIYsK1CKXN9Pa9KDdCcC7a8sLIrZtCw==
X-YMail-OSG: Pl_Kr04VM1lQq1TzKl0aH4FSrCV1Q5aoPtez1CNPs8c4x6gA5vqZHTF2iM.aAb8
 Ytae_UEf2rn4I8Hy1BFhYANy2yRhE5VjDK7Qsc62uwkosb_NyTREW58zWoMAvmUZX_sDC_vkzGEJ
 LM93cgvybjsCVGDfQxPRuMm65_NurlN7TavrvdrhBPwhNiq4tuiMRwwkNjKG6wQ3eIkjzetQMMaI
 Q8IJLL9nRghe5QrGwGsqro6ki7XHeDbpkRDHChKbGap.rQo0UyGLs1UA6YjwGiX1I5xw5v_tz6dm
 fIs6phGWL2Ud1aPlXJBX_C.jdtbhy4Oz8vc_Shaz3CkIJy260.JuuD4FA4DGAE9C3Dj4Cq3QBbZ.
 ZLN74I0cyIHgWk2M_RA.HoCPStqqxxeQi2C.BGV.HMbOULlpF53JI3lPj2.gHBdNW268mIqXPZrj
 c6kABIfjiS8XuR7ZGrGClKIjw8kndGOpPXJkJn.sV6vsmNQION_jOH8I3pKaft_G1FwwZdf_Weyf
 eyyxwmmmY8xsQ1GbuDUuF2LdWZymKTVIyBBqc7egRzT9ZkOV_WhMBt04vQfCG0lBZTCswOvob3XM
 M3qCd3ArqFXz4DJFU5UKW9U2sNqWjeVv73cv3DnDWApnV7bHGzGvpSPyqDY3qKljBwFqN21mSUwk
 FrngWgJrwWXVqC8Ij0pEN_WVJ8Jz.5uex96PGgWQOqWfIyfdYyNy.TcwS3shp_VkYkCIVeE4eACx
 yQMclavV50tLisTVYSsYhnCfJ_y.oG5TZEIzKrzYCCNFHARZ6SSa3Y6n9nsn0n0ZcyzcctF1FRBf
 iuW9nkjhAL5Heutu9EZfGuEiQ_enPYUrMFjJvel22nP88sL_g774Txfmh4jxHo2f7tdmaoVZSuq4
 aHp3tvBO6n3Tfg8mcXpkkWZ_U6r06eRGq_LOQ_mH80w_0O73f8EeCzRH50dKwrlqRslObEjPTDIz
 BsRVqGQRR6XS6eqlXu.KEzdiyQPRc2ptLY4GOzaoXaxBNfdhHATM_Bi5eo6El0ctQMKrl.KZqr1N
 JwAIbXwRwpFuu5PYMGzOE80O2s3NhUXvNXHAiia8_2A22BDHU.xd_IuVNr.C2pmtXGYS7VB1ZSwG
 hOdxZOJB_ef7BPVSiZwRGkX_TMWlLzNjmzGnnLk3MOsHJvutgZyrehgM62OxRh7k4mJ1A6xbiW1I
 5nm44dyvNmrAUN04kwEARxw9OOO0tkSArdafKhCS.7re_bhEj.ICSqZ9gzNcDX9Ce7ceGOIqWNNU
 TWwar3PdgPQE3ycAORXpQ2IogxYqHehQptZse23whtbbglgJu0cb0klMWIK5XL4gpUQ_d2wk4zq1
 yB0EFRU43TB1tr72Im_UZbgoLjw0ncx1hpSuY0GSyueJxW5xCPY_Qv3DyWkYr6RuN28YMaGuXMRo
 hUhGDKS8nBwLQqjwR7he4Il3NOk6LqxpuVL5GcWWG4rK3dsT47g--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Fri, 28 Aug 2020 12:33:41 +0000
Date:   Fri, 28 Aug 2020 12:33:37 +0000 (UTC)
From:   Mrs Faiza Mohammed <mohammedfaiza505@gmail.com>
Reply-To: faiza_mo303@yahoo.com
Message-ID: <1531811082.6619522.1598618017835@mail.yahoo.com>
Subject: Hello My Dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1531811082.6619522.1598618017835.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello My Dear,

Please do not feel disturbed for contacting you, based on the critical condition I find mine self though, it's not financial problem, but my health you might have know that cancer is not what to talk home about, I am married to Mr.Umair Mohammed who worked with Tunisia embassy in Burkina Faso for nine years before he died in the year 2012.We were married for eleven years without a child. He died after a brief illness that lasted for five days.

Since his death I decided not to remarry, When my late husband was alive he deposited the sum of US$ 9.2m (Nine million two hundred thousand dollars) in a bank in Burkina Faso, Presently this money is still in bank. And My Doctor told me that I don't have much time to live because of the cancer problem, Having known my condition I decided to hand you over this fond to take care of the less-privileged people, you will utilize this money the way I am going to instruct herein. I want you to take 30 Percent of the total money for your personal use While 70% of the money will go to charity" people and helping the orphanage.

I don't want my husband's efforts to be used by the Government. I grew up as an Orphan and I don't have anybody as my family member,

I am expecting your response to private faiza_mo303@yahoo.com

Regards,

Mrs.Faiza Mohammed.
written from Hospital.
