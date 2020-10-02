Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C26280E88
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 10:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgJBIJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 04:09:18 -0400
Received: from sonic304-20.consmr.mail.ne1.yahoo.com ([66.163.191.146]:35007
        "EHLO sonic304-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgJBIJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 04:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601626156; bh=HGZhRqMIBjbwmQqkBYEb2FImjwNvVLS6Y2TkrSSL6Ho=; h=Date:From:Reply-To:Subject:References:From:Subject; b=c1VaL+v5K6xyEdWMPjf5wRHYMKS3YG2kVPZ1OPSYvdqsgWEcys2et7JV9J9jkN276CD6wnIVpo/1qfRAv08lRs5X6n2cxARn3eL6jYsrRv+zeXOe7MxAtrAVRySWLqP05I89Zga4SxuhBSW4ypv59iO4AiiNtd1x8HDq6D4Rs0DmzFgdrC9UVBsPfFVV4TmNSG7jrBoz3oJhUXcOOqqm2CkEJBy9jKwTJC5zQj71fMpR6SgsDCh1WdJuoz9/C3r2dRxs3ZdIAua5u/PhRUt0mrQDjYxtkjoA6ZNLoFyN4ArSMJl64KFU8LURu3afszxiJW7PlSQJv0uU+leURZw/mw==
X-YMail-OSG: aQvXHYQVM1m13CjNEHfl1Hi207dMKDKYSHdQsBDsCUmxNbAL7YQ6CV0N7uD9SDF
 bR_C6.F9D9ewzHWqd7yFta692D0PTW_ESvkjZmEUGKXfQyZJm3vkSNLW2UBiOoFaDOCYRwvxiRcX
 yLt06siM1XzX3KOr.Ww2JMEXWqflZKq6bWgHojTq6Fcp6dk6kUFo_9LzrWFxbXpglA_sYJvEFv9E
 BOJkZnQUQP3nPT_en7dcYL8jFJSuANoXq_Gn3Yqs9akIgs3Tzey8HdHxCShVeZZErEl2HLt_CN63
 gWN__YOCUvPNx0fgw4Q2Rl2PY_RwXnAWQpX8WwnTLubYBuTwUxha5z0DF5j15yGbBYkWjJGuqGO.
 vlPg8OWVEVNrA4vMg3UYnd9bHLU7mMqpahkHSmSAbVgIIrLMejCebd6dsuK3OlpwfjEMhrpcpcRG
 A0CUGSj5rr8bWqLI9wPZl.LqLjRP9nhI3gDlNzITVMWqgjqm24phzXLEuD47.FP9c_1TIdQixOJm
 IfTuWWC8lhOtuvMk1E6Qo3CqMwZeU9SENTp_TqJsaxzwieXhmvvhQdP8SxwMRZEzbEbLorg686KK
 JDlmPJ.iARnBarouvQfkuTMRR.ZyGx7T1I4YWJPOthKP1Z8bGBt5qXeR9r2k5Q_xFDJcFvx4Oe88
 afLMbKDTTUqzCnR2svAVKfi_.9PEVY5ue12DiOUH7UrhXPgVW7TN3teTDBeBuXOR6t9609AfRB.y
 hRatDMZUtEvnvWgKjH1fvwOEc1w7LTNYONkA.ddO09U_PVzOwhLyuD6VVMIt8RHScLxYWdSj6F4_
 7mXpWoKTe3L6ypryCp0t28vt.f_vy5nQnNl5B9Oj4ulI6JKu285EeEbjvG6yB7qbW1bkd1pd_qbc
 FzFCYcZGQKPYygBZX_6Dof1z5ThOXk6VEd847sOSCUCkkg3L1O6E8MGsG4j09bQ_Bdv1Zu4JEHfz
 12e_NKRba_8_4S_OYUl9QGZYIQbtpK2qpC0aR.fvQj7hYHrMw8G.o0SdFdy2_vW6roVqyZqvROuf
 ThL9an6sfb7RrkLErPHv_DHHPe2cS4Q0SHURV1maW2bv.Zpz1umWK5huk_RvkTcBKXNIsiOBviqG
 Ef9RZ7AXwejUzZ0T187swwg3FSjTtSIxohVrDGPqUY7FYHIGWTthEK9bjcgWaPBFnpGgm4yTCUJK
 8fYJWItcPiM4TVNhQOCP6nKzWdvCLjT0v4q2aU3FhQqHDYgCqPtOZVL.IWxRQcBw5gstjwxdJauV
 4htfzf83vN.55_5QUgV69wvf06JN5CX9_2J5W_nI2NiGUzMfLdCrojMRzpzJJhLW9OiSqEbMaaUQ
 Ld7oeLmJvd_UboVjy3DBgDESM1svMHZLL5fg7d6aLQU.DB4unPz1YZCKoY51rWluJfieg7J.uWfY
 jHqaoapMcfZOlKWYN.2Ys2XXSvAiYoVFApXv0LWuuLkE-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Fri, 2 Oct 2020 08:09:16 +0000
Date:   Fri, 2 Oct 2020 08:09:13 +0000 (UTC)
From:   "From Miss. Juliette Kouauo" <jjuliettekouauo@gmail.com>
Reply-To: juliiettekouauo@gmail.com
Message-ID: <71678524.1107018.1601626153808@mail.yahoo.com>
Subject: ASSISTANCE TO INVEST IN YOUR COUNTRY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <71678524.1107018.1601626153808.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:42.0) Gecko/20100101 Firefox/42.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



From Miss. Juliette Kouauo
PLOT 124 RUE 19 COCODY 01.
ABIDJAN COTE D'IVOIRE.
Greetings,

ASSISTANCE TO INVEST IN YOUR COUNTRY

For sure this mail would definitely come to you as a surprise, but do take your good time to go through it, My name is Juliette Kouauo. I lost my father a year and couple of months ago. My father was a serving director of the Agro-exporting board until his death.

He was assassinated by the rebels during the political uprising in my Country. Before his death, he made a deposit of US$25.5 Million Dollars here in Cote d'ivoire which was for the purchase of cocoa processing machine and development of another factory before his untimely death.

Being that this part of the world experiences political crises time without number, there is no guarantee of lives and properties. I cannot invest this money here any long, despite the fact that it had been my late fathers industrial plans.

I want you to do me a favor to receive this funds into your country or any safer place as the beneficiary, I have plans to invest this money in continuation with the investment vision of my late father, but not in this place again rather in your country. I have the vision of going into real estate and industrial production or any profitable business venture.

I am compensating you with 15% of the total Amount, now all my hope is banked on you and I really wants to invest this money in your country, where there is stability of Government, political and economic welfare.

I will be waiting for your urgent response as to give you more details.

Thanks and remain blessed

Miss. Juliette Kouauo
