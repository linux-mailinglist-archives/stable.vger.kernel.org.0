Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C801B3A5A7B
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 22:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhFMVAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 17:00:18 -0400
Received: from bosmailout07.eigbox.net ([66.96.184.7]:60271 "EHLO
        bosmailout07.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbhFMVAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 17:00:17 -0400
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jun 2021 17:00:17 EDT
Received: from bosmailscan09.eigbox.net ([10.20.15.9])
        by bosmailout07.eigbox.net with esmtp (Exim)
        id 1lsWhN-0000lk-QM; Sun, 13 Jun 2021 16:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=hollago65i.com; s=dkim; h=Sender:Content-Transfer-Encoding:Content-Type:
        Message-ID:Reply-To:Subject:To:From:Date:MIME-Version:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jmE1AiZh2hRjSAJKb374hqGQMjwd8yzDFHujSXNaAio=; b=okaay5P3dfNo+iQ+d6jMTBilsa
        lrVCq/nY5RXrsQlPk+p0E36HARGWQXUYm6l7VOu+I4op71IfBvHtFRuP2yju2fAuYO/KQz5+PMY7X
        4MqsQvGibtO44R9rV4v/0HIKrKaiHy2w9NM8biAtj4K/IgbW7qtMZ01kqf8nXbkHeFMwbfdf+B3+H
        +07wKn43PnMTvwWc0e8MLhPDxFXiMQEzZYeXk8foNXwwur6qR2TDEED4UIc0fpTLeZQ9CmhaGFvrN
        6OPmNTeAvgMP6wFgt4PPrij3qyG865bKg6dA3inI/2YxI+3Gp0OI7iSCzQ9SjaZMPg33k4V/vs334
        yYAIhiNg==;
Received: from [10.115.3.33] (helo=bosimpout13)
        by bosmailscan09.eigbox.net with esmtp (Exim)
        id 1lsWhN-0002gx-Hk; Sun, 13 Jun 2021 16:27:13 -0400
Received: from boswebmail11.eigbox.net ([10.20.16.11])
        by bosimpout13 with 
        id GkT2250080EKGQi01kT53w; Sun, 13 Jun 2021 16:27:13 -0400
X-Authority-Analysis: v=2.3 cv=RNUo47q+ c=1 sm=1 tr=0
 a=arGavn6Z5cgUkMHml6gAfw==:117 a=VjEc6grIZYOdAKCkHpPz0Q==:17
 a=SvjdIzx6mOYA:10 a=IkcTkHD0fZMA:10 a=r6YtysWOX24A:10 a=x7bEGLp0ZPQA:10
 a=pGLkceISAAAA:8 a=vXFT2s5udkHzzsxN6-UA:9 a=QEXdDO2ut3YA:10 a=cW4oh5Qe6X0A:10
 a=GXyWIPpY65UA:10 a=Twul1aCTu4YpY56LwQMJ:22 a=20QYsiCpIQ5eNXUT7wNh:22
Received: from [127.0.0.1] (helo=homestead)
        by boswebmail11.eigbox.net with esmtp (Exim)
        id 1lsWgq-0005BL-DJ; Sun, 13 Jun 2021 16:26:40 -0400
Received: from [197.239.94.184]
 by emailmg.homestead.com
 with HTTP (HTTP/1.1 POST); Sun, 13 Jun 2021 16:26:40 -0400
MIME-Version: 1.0
Date:   Sun, 13 Jun 2021 21:26:40 +0100
From:   "Mr. Ibrahim Abdoul" <info7@hollago65i.com>
To:     info@utaka.com.ar, wida.suhaili@utb.edu.bn, 4naomie@utm.my,
        naomie@utm.my, rashidahmed@utm.my, lmhuang@utmb.edu,
        lyaa071@uts.cc.utexas.edu, masattar@uvas.edu.pk,
        xsotoandion@uvigo.es, nuoxu@uw.edu, grazyna.wiejak-roy@uwe.ac.uk,
        mmshoukr@uwo.ca, bobothet@uy.edu.mm, info@vac-star.com,
        alongwell@vaildaily.com, ricky@vassellweddings.co.uk,
        payments@venturaendo.com, edwardchun@verizon.net,
        ejzuna@verizon.net, shelbyen@verizon.net, anadon@vet.ucm.es,
        git@vger.kernel.org, stable@vger.kernel.org, kslee@vghtpe.gov.tw,
        phwang@vghtpe.gov.tw, geral@vicentevieira.pt,
        support@videostarapp.com, etrtica@vinca.rs, bentail@vip.163.com,
        blservice@vip.163.com, chen-zl@vip.163.com, kyyyzhaowei@vip.km,
        gaoshugeng@vip.sina.com, kes3u@virginia.edu, ellzey@viscom.net,
        elektraweb@visiontrading.com.pk, info@visitsanjuans.com,
        info@vistadeljardin.org, pkkishore@visto.com, kishwar@vit.ac,
        z@vitalvoices.org, Support@vlesociety.com, wandam@voamid.org,
        magicsnr@vodamail.co.za, theo@voip.co.uk, bara.sala@volny.cz,
        iownby@vols.utk.edu, pharmsto@vols.utk.edu,
        vereadornenem@voltaredonda.rj.leg.br, comercial@votarenquete.com.br
Subject: URGENT RESPONDS NEEDED
Reply-To: mr.ibrahimabdoul2020@gmail.com
Mail-Reply-To: mr.ibrahimabdoul2020@gmail.com
Message-ID: <86e22983dcb7dfaf6354f2acaccc3503@hollago65i.com>
X-Sender: info7@hollago65i.com
User-Agent: Roundcube Webmail/1.3.14
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-EN-AuthUser: info7@hollago65i.com
Sender:  "Mr. Ibrahim Abdoul" <info7@hollago65i.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

My name is Mr. Ibrahim Abdoul. If the content of this message is 
contrary to your moral ethics, please accept my apology. But, please 
treat with absolute secrecy. I am working with one of the prime banks in 
Burkina Faso. Here in this bank existed a dormant account for many 
years, which belong to one of our late foreign customer. The amount in 
this account stands at $13,300,000.00 (Thirteen Million Three Hundred 
Thousand US Dollars).

I was very fortunate to come across the deceased customer's security 
file during documentation of old and abandoned customer’s files for an 
official documentation and audit of the year 2020.

I want a foreign account where the bank will transfer this fund. I know 
you would be surprised to read this message, especially from someone 
relatively unknown to you. But, do not worry yourself so much. This is a 
genuine, risk free and legal business transaction. All details shall be 
sent to you once I hear from you.

If you are really sure of your sincerity, trustworthiness, 
accountability and confidentiality over this transaction, reply back to 
me urgently. cantact me on (mr.ibrahimabdoul2020@gmail.com)

Best regards,

Mr. Ibrahim Abdoul
cantact me on (mr.ibrahimabdoul2020@gmail.com)
