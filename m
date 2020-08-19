Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC866249A0C
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgHSKPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:15:37 -0400
Received: from sonic315-15.consmr.mail.bf2.yahoo.com ([74.6.134.125]:43019
        "EHLO sonic315-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbgHSKPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597832136; bh=vSZ7gQ8F13hDNYtYk6t77g8qrdmtAY1S6LJUlA/r/r4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=dKaRA2FbbGiqclcuyM7I0ohwqq6+qbj7bn1zRv/kzB81iIqjlzH8I4UV99EGTbl/xnDMT9TTVNSzyHWmnqA4Nw7CfgTARY0VAsgsKz4nV2PmtXcHv82jug/KP+spvZH/is3yhi1jO4SZ+JtbauC7n1pQ7/TRv9FsmWHaJVgh+MrxXTguFb9jaM/zvdu8te1ZWHq6BRSWWAPYe4FNu0fqvpQ4lA49bEWHt2hFKjHB5u4p/fZ9hDxMRF1Y9iT9DrykqL+WMbuQ1XMHgPCvn4bm5YQ7Z6ZhTA1hn+mX+iaySohYN5HwzNFYpfIb323QohUFnToDLidvItt2trxtz8CA6g==
X-YMail-OSG: jcAXDl4VM1m96_46YuiGpUYLpFFMNbKcs9HgMFYvgci1A4L6e7_Ra4KFz4AZ2Wx
 E5WMU4AbmSZaovsIlafgukI0rPIlC.K6fm0lKxAA3Z9IjDeiwzcjzHnDzkce45w2fzB_4XGG64O4
 LVm00rDsmw94hbmTb.4Rwx_c7c4b53y2msrK0j1hHyNB52aoAegpIxxCClcj58AN9t4y38LgnSHy
 cfFl.t4ZdVTSoulfoLJkLYC8JQ8Jv0LZ8d02doqvbBFki_tZlcvzU5kWU3WAIcwY_U6ahTGXd2Gf
 b5BHMkpxr1XIrfnlHtGQdUkq7X5ES0WGDviHZVRVpaJAGIuuS.sWm_bSURaQnO7Ujx_WSHi0ct4w
 uwiqHKFA6Iin1alFJLfCs_pAdEkVZo8JLW8ZOQcBwQtlnJYfYjRaoNeIqZxvjOz2bUWSipDPykhK
 64ukSVmsBRejCU3ltYtDsJBp8iKgYmafm44yRrc9WArg5qqYrUU9ER3Wfp1oKTZ2ilEti7235A_w
 p52.jFgR0gC5_RiEXdOV_wPm4ze551RvN3klb1bum3H8g7MbrWAMEhHNz4b4a9JjA9trEgF7_eo1
 wvQBztECccMnXc75uqrDO_QiKbKCw0zgVvYFTJ2uL5DVtPOZqpIcbxViUNt2RJVpRC5f_GWNT33o
 RQHxgLdElSZe6_1HrfxLu0N2NzribYjR_hLWx.e7poIFq1Z3koQA8g.Ct3O2_Fo.nIoDI9dUYlhA
 0mQprElK4TRTkoQJV0eyBKVgksKwWDr5sOf1RGAE4rLToqWvhn6uJ47RAwBACcL9ID4mPLCjFDvn
 9GwlXAC3CuWzn9VUiYib1_sFYBbral4gWB1P_y8FDam5krx_vugSWiQtcVtm3ySQNFi8H7drCg9d
 pka83DiIMGTLkqA10KPbyr7kuJbSH1o0iUIGx1O5QBTJwqTI5dEEgmSltlf_2L7EnwfMaDrEVv_a
 D8R9kxCpy9BuzAjRUpDBYZuh.Gt9Mg_ppnNZTAO9xe2TSKkBxj_FoD5TgfErdEREbeygksFCLQBy
 0HFKwpnKIt9bw0plpp0cP_hCUc8WlmAG8fDr3Ssv.5kah1FSHePw60qxm70bbvU2gehW0WHMZZ5E
 _ZDiWr81Oa6qjlJzmDEBYx6sK51ghrNi9WCuIYOUwz6QbIA0k0rsTJmM7jJyQxQKK9kMn1xGjJKp
 qpeYwwkcApAGPUpclAC4NAWb5BwM3rpoc8PeWdST9qDZ7i4WwwOTTJMP3Ih_DJKM739THUEy8h9x
 Ouv9hm11vFgvJGxV8Hk.0o2J21YrRffdnnmVmijbG_15RY8lwzS8JgRGuaryL6i0Fy.Ixbdq7RED
 bGoYdRtC.8SDJQTZN5F9q2orGK93JRngwTcB_Bgz.490sLgqzvr8-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Wed, 19 Aug 2020 10:15:36 +0000
Date:   Wed, 19 Aug 2020 10:15:35 +0000 (UTC)
From:   Mrs Faiza Mohammed <mohammedfaiza505@gmail.com>
Reply-To: faiza_mo303@yahoo.com
Message-ID: <685527774.3192966.1597832135911@mail.yahoo.com>
Subject: Hello My Dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <685527774.3192966.1597832135911.ref@mail.yahoo.com>
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
