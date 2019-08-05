Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569448249F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 20:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfHESFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 14:05:46 -0400
Received: from sonic308-9.consmr.mail.ne1.yahoo.com ([66.163.187.32]:40424
        "EHLO sonic308-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbfHESFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 14:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1565028345; bh=BpMmf+T2AISI0la30xcX53zAt7bbHA3yqFYzA96iHNo=; h=Date:From:Reply-To:Subject:From:Subject; b=bjeodukl036KH6k6j6dIJSJcNk/4dX5+NGJzRM5Yn0sKIGNv7jFxuAqnmqUaWgbGhZNV3Gru3+2DYOWneGCugYtSB3nSE/mHZCxY+96l1O9dJMKzFEyH4w8jnnNyNGYizWNZcCnpJQ90GxddMQ7s/Ki2FzwG3YS6ekUVUNAM79XoPG4PwsJn0jgYPNId6v4nO0ZCASrLVXY7Z7CmDMGbwrk8ZaIGyKFgtxOqq48h1OHKTVWBVbEhORfUukWtike8shxTJiL56QVvT7eJiBW39GyRgb024VbJiXxk0TmsiWo1fbGGjiRR1t619j+AQG83IoEEtj6qBlfPJnninytkgw==
X-YMail-OSG: o2q0Ie0VM1n7VETiAPUjcxmayJnX0k2EjoZavp6Rtg7_2jt0Kv4KzUET9e9KrG8
 XQmpNSsBCQDIyhsaC7fgtH2rvFad1cleZXLciGSttcsCp7uGj9UmrWi2OMG3Zf6VT67plP7_N_F6
 4joRIQMIFurZNccpYykhRnxwsBgs99YQnn64zst7FZj7AXXrJpfgQOIfHRfTfesvv6k29K_FKWM8
 1irdP2JVViYnXTTdKxmlXge_jOCn_RwY4gFzk_x3.fGAn.rxb0.nJs7o2DGOpmm9cyOD7TGm9Kdc
 zjJPGETPMRXjTecZTv9LcvUEJ2K6A48koNNuM9rK.lppvpjAHCZrAwhFUVur93AMHIPC3FV.hWBS
 QVAkSHToUB6XsbQYZUANs8pmF3P3dsxMETsWYXeUa6uoF.r_hUMvd58lpcMU7n2Y6P2ZL8AxIjzq
 5aUoAsMQvrxOo43ff.hPYiWoR6gzdvgzzKLV8C8BHayVDn95lLiTzLaIOoPNuKH1ywbNepVmhkRo
 _H_PsGoALWn_bkyaPlE_sJTDj0pejq_Dz5pP_NKlEUf_yfVoZmoVDSM090n.fQ3DHe9Jx9uM1Oqs
 wY1FzfVs4XXQWb4AN21Xr2W8oc0AQubToduQOyWZgruO8kOBlC79K8x7XUE87J4lUn3jLpu38PiK
 oFTk6g1WylPKrFzVkLvz5W0aWMe.iMUJJSbg9UVooa1uejmQ2jTEzl8Y0XdLWI20yMNAj91G95Jd
 duFi.AROllCjNXKGpI9qJzH3nz7Nhy5ntec_f2Bpf894DRTHapQrQxfHJQx2BGvpWU185_pF9tWb
 7gZ_H9V5CIb0FwXPRZEQGR6lMFDRmAdR0ShLBYeKC0Z0bG83fQmo4A1moK.Dm4yXqxpemYKxechR
 2ro2DNJ55myEaMOC5HYvjIO._Q4ZtZVuKBmsflOY6Ml7yIxMqN1RqjFCCfoe4zIj4PsNaIugl4O4
 yFUEgMxijNQ0OZnF3CMacGQI3x6UmpddeVizbtCkvxzvA8YrwR6OeSnFic23wAlM5XAg6DE_U_A3
 0T4OB2pm3OYsTp72SgLzIqNXA3e3ISBw9g8l2mLxWFVbcqMfM9EsbFMW0C19WwRj3HOM6wSLPlRb
 Up2vQWn282EHo15wtkLp8OrE6sollcRQslyktGKmsa5PwXkYTDVzK0dOw5uYetSxBQbqfaoYp467
 xwTyNn7xDcVSuXxMb5ZXNAXhCJgJ1enTZwXQqrE2nVWnv9N.Lnj1kW7aq2oZn5v2uuAejWWxd_71
 d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 5 Aug 2019 18:05:45 +0000
Date:   Mon, 5 Aug 2019 18:05:43 +0000 (UTC)
From:   "Mr.Jack.Rufon" <mr.jack.rufon1@gmail.com>
Reply-To: mr.jack.rufon1@gmail.com
Message-ID: <1725473896.1308737.1565028343630@mail.yahoo.com>
Subject: Hello
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My name is Mr.Jack.Rufon; I got your address in Burkina Faso chamber of commerce through details. I need your urgent assistance in Transferring the sum of (22.5, 000,000) Million Dollars fund which Belongs to our deceased customer who died in A plane crash, since the Death of this our customer the money has been in our bank without Claim. I want to release the money to you as the deceased NEXT OF KIN For the benefit of both of us. By indicating your interest I will send you the full details on how the business will be executed. I need to Hear from you urgent so that I will give you more information regarding this transaction.

Waiting for your urgent response so that we will starts immediately.

Thanks,
Mr.Jack.Rufon.
