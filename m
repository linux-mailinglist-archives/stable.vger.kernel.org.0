Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1333273F40
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 12:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgIVKIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 06:08:39 -0400
Received: from sonic308-19.consmr.mail.sg3.yahoo.com ([106.10.241.209]:41473
        "EHLO sonic308-19.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgIVKIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 06:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600769316; bh=0j3O1KE5D4d5mMRMV0JPR4zma4b4RN3gVv5F3zquQys=; h=Date:From:Reply-To:Subject:References:From:Subject; b=iqzEfClXH6HTeY9SU6OAIZjdfGrFlF0gdF0RJwMxyqxxcfD7zkyXHhCOalNAzfN1FlgHPZhhWDdLa7NI7g+8H21FcZcXlYF8MuDk0dAMieeRzKksc1+sSuOA/tuUbGVmWTDCztjxGwLPqMAzTZhy/g8bP4KQTZEv39YzWlsihY5wDvMY/prNHL0k8HmT017rGAMB7Pln2qZDJXOeiYF5nXebZruouZg1NRhggKJ+rg9nZCqPmBlsEb7Qknw/gHDxiT77yvpt1qGT79yDECsChmsVaxURMWEg1qZOROvXVYCAycrciXqgVb2fIXandRmyL6COLYbUoV7qvABo7G7mEw==
X-YMail-OSG: lBERmPUVM1lpwYiI5jsnnIzgftwKgsS_wDr_eD.Op6F2.cR_5VrM0z68PoRPXRU
 QVdXeWIn1gQE0fJeBSBGRNUW6HbA.8IQDx7smjD3G9VoMpG16ihdXiNmSuGIN4r20dhftWJxISLl
 06pQgU5.ieJ.Is68tbKti_f8GVELYh7NtLNZ9CQjWDkrdoZqS025u3ZP0QFZsKSVoE6Q0n2pCqd3
 uqyUm4P.wumtLEbNnQHIpJ9VC91X0wQoRo4j2yW7ZNKJUpaZ0P_rjHJsex4BHd5PYOysbI7yQHP1
 vsL.XqqVrZIEyFZw3JEM5297AgOvLsDyiGsq9QRe5shCpz_G1QJixfxB8eB5iUpQkCn1Gv3pl6_E
 CShK5_8xha8338phS7kXZKYYsAe8Z92hebWbeYz0VV6FAizYeAcUeskUhgJdHZmkBzLrbe9_Ajz.
 jS74ox.FHGjiSp3PYVh8lzfIn._mJ9wcH3GCeLbMke7e5UeMNXvbI7CGRwDHOn1wAa_ecfVx1vmF
 jEpk5piPk2k8xv8koJOySRKOlbvlbFR59WSnB4NfbOuFTbj_DfqNbS7YYZhgNxLFmc8BKdPmLP6I
 LKk8Vg5bVmrFfmEftlb9aiUubKj5Q3r2JmoC3IJiSGef1fmRYwUP9wcGOwyjAl48COjmTs3xWEgv
 f5bmGLbQVs4MrOtWPJcHxHdGdx16HwpnNjcsK5sSjLIxAbJoJryrdx31uX5UBwnMjKwdGG7zX_Sq
 z.9CCoHCQ_2F9H5EEB6ZOzl0mhn4wH8bCIqmUr.eKWFPElCbWkd9xq3y3G9ahLgd6zcRsB0hE8RB
 V1gexJ79U.Nb_dHmNyWMG84vMklf8ZAJi47OA3qec9mshcH6JO1DS5Pc_pSDq13eKEN20DpmKS72
 VPKQ2YLqorImCFAk7U2._6pSUL9PUKNFafKmmQ3xIlb6NE7Xs7TCFd9zoDzPyWOPS1EIDzEmHWQc
 ydMZ5U6irvFl2__sCBNPG9iDlW5t8X44GD1Jpy2h_7yRoCVZBnVWrg12HPv9LlIXDswo4MoobQqv
 YjpHwVXoh_bCPkmWZlaE2.GwHrq3U6V25soxplky6YjXtyAcurTPDreyatJXhC39BlNLgBZJ5SDq
 6On9g8UktuuEj45pnvqJc_sYAf97S_.FhBVSvk4Ba9jxtzdotp7DgFoQPVvYjA0NHGL.NFbf7XmW
 IvLl6ypyA8u2GE6tcwEkAkuUFAu9.p0NeBgz.iNnyR4ySZP4hKYzha7mmBPk_42nLp9OuYdQOSgZ
 _Jt.kPEDu1WRso5_MZgB1k4zRjolPy7pSx96qebxi1YgvmzAwkf5IBvBgwVmB6FlT8Wu_fOAdOar
 xsI9dukZJ9nvK1wyWjW4n5lJo6dyd0XCWKKf7wSY0mwpGOLRBwIKCvUbPEKTu3OZrGocyrAke9vo
 .Au8fywGX.H7SPNL2bxP4dDVAZgMpr7rGIyRutq9FwA6gb33OmXpZXqzH
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.sg3.yahoo.com with HTTP; Tue, 22 Sep 2020 10:08:36 +0000
Date:   Tue, 22 Sep 2020 10:08:32 +0000 (UTC)
From:   deedeepaul212@gmail.com
Reply-To: deedeepaul22@gmail.com
Message-ID: <781986591.3731073.1600769312434@mail.yahoo.com>
Subject: Dear partner,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <781986591.3731073.1600769312434.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:43.0) Gecko/20100101 Firefox/43.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear partner,

my name is Mr. Deedee Paul. I am working with one of the prime banks in Burkina Faso. Here in this bank existed a dormant account for many years, which belonged to one of our late foreign customer. The amount in this account stands at $13,300,000.00 (Thirteen Million Three Hundred Thousand USA Dollars).

I want a foreign account where the bank will transfer this fund. I know you would be surprised to read this message, especially from someone relatively unknown to you. But, do not worry yourself so much. This is a genuine, risk free and legal business transaction.

Reply back to me with your details information, if you are interested. and all my details information and the details of this business transaction shall be sent to you once I hear from you.

Best regards,
Mr. Deedee Paul
