Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E66410B45
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 13:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhISL2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 07:28:10 -0400
Received: from imsva.erbakan.edu.tr ([95.183.198.89]:44386 "EHLO
        imsva.erbakan.edu.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhISL2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Sep 2021 07:28:10 -0400
X-Greylist: delayed 1290 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Sep 2021 07:28:10 EDT
Received: from imsva.erbakan.edu.tr (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61A941246D3;
        Sun, 19 Sep 2021 13:57:16 +0300 (+03)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=erbakan.edu.tr;
        s=dkim; t=1632049036;
        bh=jGcawKY0726XjzhdnDY1eRO4ONAA1jUdQlGOScMASnU=; h=Date:From:To;
        b=qjHFE811v1iqTSLu70NcXyXBAj7JSEG5oCQqXq0e+fX8lus49tZZu4wqMh/5EZRSu
         O41gtHy9u6Q41WVySRofL/GKgTFSliO/nWVL/MsqkeuMSbPq6BY0hP0hysNZqWAT+h
         0bBc5gSgpkxA+uSY0uHgruxCdAsSjzIvaD6B5mG0=
Received: from imsva.erbakan.edu.tr (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EF5B1246D0;
        Sun, 19 Sep 2021 13:57:16 +0300 (+03)
Received: from eposta.erbakan.edu.tr (unknown [172.42.40.30])
        by imsva.erbakan.edu.tr (Postfix) with ESMTPS;
        Sun, 19 Sep 2021 13:57:16 +0300 (+03)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by eposta.erbakan.edu.tr (Postfix) with ESMTP id CE6A71217C06F;
        Sun, 19 Sep 2021 14:05:10 +0300 (+03)
Received: from eposta.erbakan.edu.tr ([127.0.0.1])
        by localhost (eposta.erbakan.edu.tr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id SS-2W2CqfV0N; Sun, 19 Sep 2021 14:05:10 +0300 (+03)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by eposta.erbakan.edu.tr (Postfix) with ESMTP id 363141217C074;
        Sun, 19 Sep 2021 14:05:09 +0300 (+03)
DKIM-Filter: OpenDKIM Filter v2.10.3 eposta.erbakan.edu.tr 363141217C074
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=erbakan.edu.tr;
        s=9A114B22-0D17-11E9-AE7D-5CB170D0BDE7; t=1632049509;
        bh=UE+6Rh6p+D/Q/qnCC1rilRTfAwcozVy4J0wYoa1QJws=;
        h=Date:From:Message-ID:MIME-Version;
        b=hfEM4rA0bUbo9Zyv54RSV6CesX+gjQaCUuxdrpIZODF7yDC65j5bsi/fXKaUMLj1F
         UCD1Hij1E/3kgk969OFbGv5L0ekMLN/qLybFzwxxze2XYXI79oJLxliihvKc/ZzmXz
         1HX+S7KmiHvwphuO6LZXhIaLD2yOxEq9cSTjse06pANDyRYiAiJwj5c2LueUqYr+Fq
         1oPuEn38DBECOVZPGPbFsnFyg5JgNT/QPm4ci7PN+mpBcWadVio9oYxYdYqph8SZPV
         nw6yyT9Hidk8iuTFhkCihDeFsPxBZIzud2I8Vo2B18HfwnSA+9HnMIknfXec4eGNMz
         m28q4B3sCLrUA==
X-Virus-Scanned: amavisd-new at eposta.erbakan.edu.tr
Received: from eposta.erbakan.edu.tr ([127.0.0.1])
        by localhost (eposta.erbakan.edu.tr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id d4icBEdytRRP; Sun, 19 Sep 2021 14:05:07 +0300 (+03)
Received: from eposta.erbakan.edu.tr (eposta.konya.edu.tr [172.42.44.72])
        by eposta.erbakan.edu.tr (Postfix) with ESMTP id 8AF7E1217C06F;
        Sun, 19 Sep 2021 14:05:06 +0300 (+03)
Date:   Sun, 19 Sep 2021 14:05:05 +0300 (EET)
From:   =?utf-8?B?eWFyxLHFn21h?= gsf <yarismagsf@erbakan.edu.tr>
Reply-To: =?utf-8?B?eWFyxLHFn21h?= gsf <oasisportfb@gmail.com>
Message-ID: <1727401060.507086.1632049505971.JavaMail.zimbra@erbakan.edu.tr>
Subject: Re: Quick loan
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.11_GA_3799 (ZimbraWebClient - GC92 (Win)/8.8.11_GA_3787)
Thread-Index: P2TDt7MocwE3ITXoffzrn6NGArpNng==
Thread-Topic: Quick loan
To:     undisclosed-recipients:;
X-TM-AS-GCONF: 00
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oasis is offering quick loans, without credit check to old and new customers. We give Short or long term loan with a relatively low interest rate of about 0.2% on Instant approval.
Oasis Fintech a onetime solution to all your financial need. 
Contact us today via email, oasisportfb@gmail.com,  and complete the loan form below....
Your Full Name:
Amount Required:
Contact Phone #:
Occupation:
Loan Duration:
Purpose:
Location:
 
Ms. Bauer
Contact us via: email:  oasisportfb@gmail.com
 


